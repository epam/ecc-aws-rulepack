resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.dax
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/eo_role_boundary"
  provider             = aws.provider2

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "dax.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_dax_cluster" "this" {
  cluster_name       = module.naming.resource_prefix.dax
  iam_role_arn       = aws_iam_role.this.arn
  node_type          = "dax.t2.small"
  replication_factor = 1
  provider           = aws.provider2
}