 resource "aws_iam_instance_profile" "this" {
  name = "371_profile_red"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = "371_role_red"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
     }
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
} 
