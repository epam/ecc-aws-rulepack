resource "aws_emr_cluster" "this" {
  name                              = "258_emr_cluster_green"
  release_label                     = "emr-5.33.0"
  applications                      = ["Spark"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  ebs_root_volume_size              = 10
  security_configuration            = aws_emr_security_configuration.this.name

  ec2_attributes {
    subnet_id                         = aws_subnet.this.id
    emr_managed_master_security_group = aws_security_group.this.id
    emr_managed_slave_security_group  = aws_security_group.this.id
    instance_profile                  = aws_iam_instance_profile.this.arn
  }

  master_instance_group {
    name           = "258_master_instance_group_green"
    instance_type  = "m4.large"
    instance_count = 1
  }

  core_instance_group {
    name           = "258_core_instance_group_green"
    instance_count = 1
    instance_type  = "m4.large"
  }

  service_role = aws_iam_role.emr_service_role.arn

  depends_on = [aws_subnet.this, aws_iam_role.emr_service_role, aws_iam_role.emr_ec2_instance_profile, aws_iam_instance_profile.this, aws_s3_bucket.this, aws_s3_bucket_acl.this]
}

resource "aws_emr_security_configuration" "this" {
  name = "258_security_configuration_green"
  configuration = <<EOF
{
  "EncryptionConfiguration": {
    "EnableAtRestEncryption": true,
    "AtRestEncryptionConfiguration": {
      "S3EncryptionConfiguration": {
        "EncryptionMode": "SSE-KMS",
        "AwsKmsKey": "${aws_kms_key.this.arn}"
      },
      "LocalDiskEncryptionConfiguration": {
        "EncryptionKeyProviderType": "AwsKms",
        "AwsKmsKey": "${aws_kms_key.this.arn}"
      }
    },
    "EnableInTransitEncryption": true,
    "InTransitEncryptionConfiguration" : {
      "TLSCertificateConfiguration" : {
        "CertificateProviderType" : "PEM",
        "S3Object" : "s3://${aws_s3_bucket.this.id}/my-certs.zip"
      }
    }
  }
}
EOF
}



resource "aws_kms_key" "this" {
  description             = "258_kms_key_green"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/258_kms_key_green"
  target_key_id = aws_kms_key.this.key_id
}