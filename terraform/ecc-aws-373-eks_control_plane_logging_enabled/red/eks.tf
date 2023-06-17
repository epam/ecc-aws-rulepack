resource "aws_eks_cluster" "this" {
  name                      = "373_eks_cluster_red"
  role_arn                  = aws_iam_role.this.arn
  enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler"]
  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Cluster_Policy,
    aws_iam_role_policy_attachment.Service_Policy,
  ]
}

resource "aws_iam_role" "this" {
  name = "eks-373-cluster-red"

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

