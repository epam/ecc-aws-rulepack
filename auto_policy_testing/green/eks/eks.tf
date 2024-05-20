# EKS takes about 10 minutes to deploy

resource "aws_eks_cluster" "this" {
  name                      = "${module.naming.resource_prefix.eks}"
  role_arn                  = aws_iam_role.this.arn
  version                   = "1.29"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = data.terraform_remote_state.common.outputs.kms_key_arn
    }
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.this1.id, aws_security_group.this2.id]
    public_access_cidrs     = ["11.2.3.4/32"]
    subnet_ids              = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Cluster_Policy,
    aws_iam_role_policy_attachment.Service_Policy,
  ]
}

resource "aws_security_group" "this1" {
  name   = "${module.naming.resource_prefix.security_group}-1"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

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

resource "aws_security_group" "this2" {
  name   = "${module.naming.resource_prefix.security_group}-2"
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}