output "eks" {
  value = {
    eks                                           = aws_eks_cluster.this1.arn
    ecc-aws-225-eks_control_plane_logging_enabled = [aws_eks_cluster.this1.arn, aws_eks_cluster.this2.arn]
  }
}
