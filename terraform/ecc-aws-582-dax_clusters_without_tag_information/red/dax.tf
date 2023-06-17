resource "aws_iam_role" "this" {
  name = "role_for_dax_582_red"

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
  cluster_name       = "cluster-582-red"
  iam_role_arn       = aws_iam_role.this.arn
  node_type          = "dax.r4.large"
  replication_factor = 1
}