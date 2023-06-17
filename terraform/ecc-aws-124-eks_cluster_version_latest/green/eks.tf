resource "aws_eks_cluster" "this" {
  name     = "124_eks_cluster_green"
  role_arn = aws_iam_role.this.arn
  version  = "1.25"

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.Cluster_Policy,
    aws_iam_role_policy_attachment.Service_Policy,
  ]
}

resource "aws_iam_role" "this" {
  name = "eks-124-cluster-green"

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