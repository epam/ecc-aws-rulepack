resource "aws_sagemaker_endpoint_configuration" "this" {
  name         = "${module.naming.resource_prefix.sagemaker_endpoint_config}"
  kms_key_arn  = data.terraform_remote_state.common.outputs.kms_key_arn

  production_variants {
    variant_name           = "${module.naming.resource_prefix.sagemaker_endpoint_config}"
    model_name             = aws_sagemaker_model.this.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"
  }
}

resource "aws_sagemaker_model" "this" {
  name                     = "${module.naming.resource_prefix.sagemaker_model}"
  execution_role_arn       = aws_iam_role.this.arn
  enable_network_isolation = true

  primary_container {
    image = data.aws_sagemaker_prebuilt_ecr_image.this.registry_path
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_sagemaker_notebook_instance" "this" {
  name                   = "${module.naming.resource_prefix.sagemaker_notebook}"
  role_arn               = aws_iam_role.this.arn
  kms_key_id             = data.terraform_remote_state.common.outputs.kms_key_arn
  instance_type          = "ml.t2.medium"
  subnet_id              = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  security_groups        = [aws_security_group.this.id]
  direct_internet_access = "Disabled"
  root_access            = "Disabled"
}

resource "aws_iam_role" "this2" {
  name = "${module.naming.resource_prefix.sagemaker_notebook}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "sagemaker.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_security_group" "this" {
  name   = "${module.naming.resource_prefix.sagemaker_notebook}"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
