resource "aws_emr_cluster" "this" {
  name                              = "257_emr_cluster_green"
  release_label                     = "emr-5.33.0"
  applications                      = ["Spark"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  ebs_root_volume_size              = 10
  security_configuration = "${aws_emr_security_configuration.this.name}"

  ec2_attributes {
    subnet_id                         = aws_subnet.this.id
    emr_managed_master_security_group = aws_security_group.this.id
    emr_managed_slave_security_group  = aws_security_group.this.id
    instance_profile                  = aws_iam_instance_profile.this.arn
  }

  master_instance_group {
    name           = "257_master_instance_group_green"
    instance_type  = "m4.large"
    instance_count = 1
  }

  core_instance_group {
    name           = "257_core_instance_group_green"
    instance_count = 1
    instance_type  = "m4.large"
  }

  kerberos_attributes {
    kdc_admin_password = random_password.this.result
    cross_realm_trust_principal_password = random_password.this.result
    realm              = "EC2.INTERNAL"
  }

  service_role = aws_iam_role.emr_service_role.arn

  depends_on = [aws_subnet.this, aws_iam_role.emr_service_role, aws_iam_role.emr_ec2_instance_profile, aws_iam_instance_profile.this]
}

resource "aws_emr_security_configuration" "this" {
  name = "257_kerberos_green"

  configuration = <<EOF
{
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