resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# NAT must be in the public subnet (IGW route); instance uses the private subnet.
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = data.terraform_remote_state.common.outputs.vpc_subnet_2_id

  depends_on = [aws_internet_gateway.this, aws_route_table_association.public]
}

resource "aws_internet_gateway" "this" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = data.terraform_remote_state.common.outputs.vpc_subnet_2_id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "this" {
  domain = "vpc"
}

resource "aws_route_table" "private" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  route_table_id = aws_route_table.private.id
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${module.naming.resource_prefix.nat_gateway}-keypair"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  user_data              = file("userdata.sh")
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  iam_instance_profile   = aws_iam_instance_profile.this.name
  key_name               = aws_key_pair.this.key_name

  # Networking + IAM must be ready so SSM can register via the NAT
  depends_on = [
    aws_nat_gateway.this,
    aws_route_table_association.private,
    aws_iam_role_policy_attachment.this,
  ]
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Generate outbound traffic through the NAT and wait until CloudWatch
# BytesOutToDestination is visible (ecc-aws-573); scan otherwise sees missing-value 0.
resource "null_resource" "generate_nat_traffic" {
  depends_on = [
    aws_instance.this,
    aws_nat_gateway.this,
    aws_route_table_association.private,
  ]

  triggers = {
    instance_id    = aws_instance.this.id
    nat_gateway_id = aws_nat_gateway.this.id
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = replace(<<-EOT
      set -euo pipefail
      INSTANCE_ID='${self.triggers.instance_id}'
      NAT_ID='${self.triggers.nat_gateway_id}'
      REGION='${var.region}'

      aws ec2 wait instance-status-ok --instance-ids "$INSTANCE_ID" --region "$REGION"

      STATUS=""
      for i in $(seq 1 60); do
        STATUS=$(aws ssm describe-instance-information \
          --region "$REGION" \
          --filters "Key=InstanceIds,Values=$INSTANCE_ID" \
          --query 'InstanceInformationList[0].PingStatus' \
          --output text 2>/dev/null | tr -d '\r\n' || true)
        if [ "$STATUS" = "Online" ]; then
          break
        fi
        sleep 10
      done
      if [ "$STATUS" != "Online" ]; then
        echo "SSM agent not Online for $INSTANCE_ID (last status=$STATUS)" >&2
        exit 1
      fi

      send_pings() {
        aws ssm send-command \
          --region "$REGION" \
          --instance-ids "$INSTANCE_ID" \
          --document-name "AWS-RunShellScript" \
          --parameters commands="ping -c 30 google.com ; ping -c 30 aws.amazon.com ; curl -s -o /dev/null https://example.com || true" \
          --query 'Command.CommandId' --output text | tr -d '\r\n'
      }

      COMMAND_ID=$(send_pings)
      aws ssm wait command-executed --region "$REGION" --command-id "$COMMAND_ID" --instance-id "$INSTANCE_ID" || true

      # NAT CW metrics can lag several minutes after traffic
      for i in $(seq 1 60); do
        END=$(date -u +%Y-%m-%dT%H:%M:%SZ)
        START=$(date -u -d '2 hours ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-2H +%Y-%m-%dT%H:%M:%SZ)
        BYTES=$(aws cloudwatch get-metric-statistics \
          --region "$REGION" \
          --namespace AWS/NATGateway \
          --metric-name BytesOutToDestination \
          --dimensions Name=NatGatewayId,Value="$NAT_ID" \
          --start-time "$START" \
          --end-time "$END" \
          --period 60 \
          --statistics Sum \
          --query 'sum(Datapoints[].Sum)' \
          --output text 2>/dev/null | tr -d '\r\n' || true)
        case "$BYTES" in
          None|"") BYTES=0 ;;
        esac
        echo "NAT $NAT_ID BytesOutToDestination Sum=$BYTES (attempt $i)"
        if awk "BEGIN {exit !($BYTES > 0)}"; then
          exit 0
        fi
        # Keep pushing traffic while waiting for metrics
        if [ $((i % 3)) -eq 0 ]; then
          COMMAND_ID=$(send_pings)
          aws ssm wait command-executed --region "$REGION" --command-id "$COMMAND_ID" --instance-id "$INSTANCE_ID" || true
        fi
        sleep 30
      done

      echo "Timed out waiting for NAT CloudWatch BytesOutToDestination > 0" >&2
      exit 1
    EOT
    , "\r", "")
  }
}

resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.nat_gateway
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/eo_role_boundary"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = module.naming.resource_prefix.nat_gateway
  role = aws_iam_role.this.name
}
