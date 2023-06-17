resource "aws_eks_cluster" "this" {
  name     = "248_eks_cluster_red"
  role_arn = aws_iam_role.this.arn

  vpc_config {
    subnet_ids         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_group_ids = [aws_security_group.this.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}