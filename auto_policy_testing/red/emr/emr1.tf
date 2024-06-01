# time to deploy is about 10 min

resource "aws_emr_cluster" "this1" {
  provider              = aws.provider2
  name                              = "${module.naming.resource_prefix.emr}-1"
  release_label                     = "emr-7.1.0"
  applications                      = ["Spark"]
  ebs_root_volume_size              = 15
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  security_configuration = "${aws_emr_security_configuration.this.name}"

  ec2_attributes {
    subnet_id                         = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
    emr_managed_master_security_group = aws_security_group.this.id
    emr_managed_slave_security_group  = aws_security_group.this.id
    instance_profile                  = aws_iam_instance_profile.this.arn
  }

  master_instance_group {
    name           = "${module.naming.resource_prefix.ec2_instance}-master"
    instance_type  = "m4.large"
    instance_count = 1
  }

  core_instance_group {
    name           = "${module.naming.resource_prefix.ec2_instance}-core"
    instance_count = 1
    instance_type  = "m4.large"
  }

  service_role = aws_iam_role.emr_service_role.arn

  tags = {
    for-use-with-amazon-emr-managed-policies = true
  }

  depends_on = [aws_iam_role.emr_service_role, aws_iam_role.emr_ec2_instance_profile, aws_iam_instance_profile.this]
}

resource "aws_emr_security_configuration" "this" {
  name = module.naming.resource_prefix.emr

  configuration = <<EOF
{
  "EncryptionConfiguration": {
    "EnableAtRestEncryption": true,
    "AtRestEncryptionConfiguration": {
      "LocalDiskEncryptionConfiguration": {
        "EncryptionKeyProviderType": "AwsKms",
        "AwsKmsKey": "${aws_kms_key.this.arn}"
      }
    },
    "EnableInTransitEncryption": false
  }
}
EOF
}

resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt secret parameters"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/${module.naming.resource_prefix.kms_key}"
  target_key_id = aws_kms_key.this.key_id
}