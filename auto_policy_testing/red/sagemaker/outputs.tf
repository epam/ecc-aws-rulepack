output "sagemaker" {
  value = {
    sagemaker-endpoint-config = aws_sagemaker_endpoint_configuration.this.arn
    sagemaker-model = aws_sagemaker_model.this.arn
    sagemaker-notebook = aws_sagemaker_notebook_instance.this.arn
  }
}
