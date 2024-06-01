# time to deploy is about 10 min

resource "aws_emr_cluster" "this" {
  name                              = module.naming.resource_prefix.emr
  release_label                     = "emr-7.1.0"
  applications                      = ["Spark"]
  ebs_root_volume_size              = 15
  termination_protection            = true
  keep_job_flow_alive_when_no_steps = true
  security_configuration = "${aws_emr_security_configuration.this.name}"
  log_uri                           = "s3://${aws_s3_bucket.this.id}/"

  ec2_attributes {
    subnet_id                         = data.terraform_remote_state.common.outputs.vpc_subnet_private_1_id
    emr_managed_master_security_group = aws_security_group.master_security_group.id
    emr_managed_slave_security_group  = aws_security_group.slave_security_group.id
    instance_profile                  = aws_iam_instance_profile.this.arn
    service_access_security_group     = aws_security_group.service_access_security_group.id
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

  kerberos_attributes {
    kdc_admin_password = random_password.this.result
    cross_realm_trust_principal_password = random_password.this.result
    realm              = "EC2.INTERNAL"
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
      "S3EncryptionConfiguration": {
        "EncryptionMode": "SSE-KMS",
        "AwsKmsKey": "${data.terraform_remote_state.common.outputs.kms_key_arn}"
      },
      "LocalDiskEncryptionConfiguration": {
        "EncryptionKeyProviderType": "AwsKms",
        "AwsKmsKey": "${data.terraform_remote_state.common.outputs.kms_key_arn}"
      }
    },
    "EnableInTransitEncryption": true,
    "InTransitEncryptionConfiguration" : {
      "TLSCertificateConfiguration" : {
        "CertificateProviderType" : "PEM",
        "S3Object" : "s3://${aws_s3_bucket.this.id}/my-certs.zip"
      }
    }
    },
    "InstanceMetadataServiceConfiguration" : {
      "MinimumInstanceMetadataServiceVersion": 2,
      "HttpPutResponseHopLimit": 1
    },
    "AuthenticationConfiguration": {
        "KerberosConfiguration": {
        "Provider": "ClusterDedicatedKdc",
        "ClusterDedicatedKdcConfiguration": {
            "TicketLifetimeInHours": 24,
            "CrossRealmTrustConfiguration": {
            "Realm": "AD.DOMAIN.COM",
            "Domain": "ad.domain.com",
            "AdminServer": "ad.domain.com",
            "KdcServer": "ad.domain.com"
            }
        }
        }
    }
}
EOF
}

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "null_resource" "this1" {
  triggers = {
    emr = aws_emr_cluster.this.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws emr modify-cluster-attributes --cluster-id ${self.triggers.emr} --no-termination-protected"
  }

  depends_on = [aws_emr_cluster.this]
}