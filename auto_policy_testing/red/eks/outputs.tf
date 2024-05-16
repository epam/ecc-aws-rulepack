output "eks" {
  value = {
    eks = aws_eks_cluster.this.arn
  }
}
