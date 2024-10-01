output "glue-catalog" {
  value = {
    glue-catalog                = aws_glue_data_catalog_encryption_settings.this.id
  }
}
