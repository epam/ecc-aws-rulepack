# EKS takes about 10 minutes to deploy

resource "aws_eks_cluster" "this1" {
  name     = "${module.naming.resource_prefix.eks}-1"
  role_arn = aws_iam_role.this.arn
  version  = "1.27"
  provider = aws.provider2

  vpc_config {
    endpoint_public_access = true
    public_access_cidrs    = ["0.0.0.0/0"]
    subnet_ids             = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
    security_group_ids     = [aws_security_group.this.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Cluster_Policy,
    aws_iam_role_policy_attachment.Service_Policy,
  ]
}

resource "aws_eks_cluster" "this2" {
  name                      = "${module.naming.resource_prefix.eks}-2"
  role_arn                  = aws_iam_role.this.arn
  version                   = "1.29"
  enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids         = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
    security_group_ids = [aws_security_group.this.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Cluster_Policy,
    aws_iam_role_policy_attachment.Service_Policy,
  ]
}

resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = [443, 22]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      self      = true

    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}