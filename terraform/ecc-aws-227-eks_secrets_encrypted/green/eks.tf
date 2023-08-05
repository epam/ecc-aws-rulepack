resource "aws_eks_cluster" "this" {
  name                      = "227_eks_cluster_green"
  role_arn                  = aws_iam_role.this.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }
  
  encryption_config {
        resources = [ "secrets" ]
        provider {
            key_arn = aws_kms_key.this.arn
        }
    }


  depends_on = [
    aws_iam_role_policy_attachment.Cluster_Policy,
    aws_iam_role_policy_attachment.Service_Policy,
  ]
}

resource "aws_iam_role" "this" {
  name = "eks-227-cluster-green"

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

