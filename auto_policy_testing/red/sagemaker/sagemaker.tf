resource "aws_sagemaker_endpoint_configuration" "this" {
  name = module.naming.resource_prefix.sagemaker_endpoint_config

  production_variants {
    variant_name           = module.naming.resource_prefix.sagemaker_endpoint_config
    model_name             = aws_sagemaker_model.this.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"
  }
}

resource "aws_sagemaker_model" "this" {
  name                     = module.naming.resource_prefix.sagemaker_model
  execution_role_arn       = aws_iam_role.this.arn
  enable_network_isolation = false

  primary_container {
    image = data.aws_sagemaker_prebuilt_ecr_image.this.registry_path
  }

  depends_on = [aws_iam_role_policy_attachment.sagemaker]
}

resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.sagemaker_notebook
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/eo_role_boundary"
  assume_role_policy   = data.aws_iam_policy_document.this.json
  provider             = aws.provider2
}

resource "aws_iam_role_policy_attachment" "sagemaker" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  provider   = aws.provider2

  provisioner "local-exec" {
    command = "sleep 20"
  }
}

resource "aws_sagemaker_notebook_instance" "this" {
  name                   = module.naming.resource_prefix.sagemaker_notebook
  role_arn               = aws_iam_role.this.arn
  instance_type          = "ml.t2.medium"
  direct_internet_access = "Enabled"
  root_access            = "Enabled"
  provider               = aws.provider2

  depends_on = [aws_iam_role_policy_attachment.sagemaker]
}
