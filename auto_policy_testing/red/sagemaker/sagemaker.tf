resource "aws_sagemaker_endpoint_configuration" "this" {
  name         = "${module.naming.resource_prefix.sagemaker_endpoint_config}"

  production_variants {
    variant_name           = "${module.naming.resource_prefix.sagemaker_endpoint_config}"
    model_name             = aws_sagemaker_model.this.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"
  }
}

resource "aws_sagemaker_model" "this" {
  name                     = "${module.naming.resource_prefix.sagemaker_model}"
  execution_role_arn       = aws_iam_role.this.arn
  enable_network_isolation = false

  primary_container {
    image = data.aws_sagemaker_prebuilt_ecr_image.this.registry_path
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_sagemaker_notebook_instance" "this" {
  name                   = "${module.naming.resource_prefix.sagemaker_notebook}"
  role_arn               = aws_iam_role.this.arn
  instance_type          = "ml.t2.medium"
  direct_internet_access = "Enabled"
  root_access            = "Enabled"
  provider               = aws.provider2
}

resource "aws_iam_role" "this2" {
  name = "${module.naming.resource_prefix.sagemaker_notebook}"

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
