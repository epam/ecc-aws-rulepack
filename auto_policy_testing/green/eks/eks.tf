resource "aws_eks_cluster" "this" {
  name                      = "${module.naming.resource_prefix.eks}"
  role_arn                  = aws_iam_role.this.arn
  version                   = "1.28"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
 
  encryption_config {
    resources = [ "secrets" ]
    provider {
      key_arn = data.terraform_remote_state.common.outputs.kms_key_arn
    }
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.this.id]
    public_access_cidrs     = ["11.2.3.4/32"]
    subnet_ids              = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Cluster_Policy,
    aws_iam_role_policy_attachment.Service_Policy,
  ]
}

resource "aws_iam_role" "this" {
  name = "${module.naming.resource_prefix.eks}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "Cluster_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "Service_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.this.name
}

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "this" {
  name   = "226_security_group_green"
  vpc_id = aws_vpc.this.id

  dynamic "ingress" {
    for_each = [443, 10250]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      self      = true

    }
  }


  dynamic "egress" {
    for_each = [443, 10250]
    content {
      from_port = egress.value
      to_port   = egress.value
      protocol  = "tcp"
      self      = true

    }
  }
}