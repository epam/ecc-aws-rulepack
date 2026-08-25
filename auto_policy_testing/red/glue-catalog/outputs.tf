output "glue-catalog" {
  value = {
    glue-catalog                                                          = data.aws_caller_identity.this.account_id
    ecc-aws-253-glue_data_catalog_encrypted_with_kms_customer_master_keys = data.aws_caller_identity.this.account_id
    ecc-aws-365-glue_connection_passwords_encrypted                       = data.aws_caller_identity.this.account_id
  }
}
