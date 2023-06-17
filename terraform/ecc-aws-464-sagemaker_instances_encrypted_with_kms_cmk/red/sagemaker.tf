resource "aws_sagemaker_notebook_instance" "this" {
  name                   = "464-sagemaker-notebook-instance-red"
  role_arn               = aws_iam_role.this.arn
  instance_type          = "ml.t2.medium"
}


resource "aws_iam_role" "this" {
  name = "464_role_red"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "sagemaker.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
