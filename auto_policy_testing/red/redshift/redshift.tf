resource "aws_redshift_cluster" "this" {
  cluster_identifier  = module.naming.resource_prefix.redshift_cluster
  database_name       = "dev"
  master_username     = "awsuser"
  master_password     = random_password.this.result
  node_type           = "ra3.xlplus"
  skip_final_snapshot = true
  # New clusters are always encrypted (AWS default since Jan 2025); ecc-aws-126 excepted for red
  encrypted                            = true
  allow_version_upgrade                = false
  enhanced_vpc_routing                 = false
  availability_zone_relocation_enabled = false
  provider                             = aws.provider2
  cluster_parameter_group_name         = aws_redshift_parameter_group.this.name
}

# RA3 clusters often come up with AZ relocation enabled despite TF=false; disable for ecc-aws-449
resource "null_resource" "disable_az_relocation" {
  depends_on = [aws_redshift_cluster.this]

  triggers = {
    cluster_id = aws_redshift_cluster.this.cluster_identifier
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = replace(<<-EOT
      set -euo pipefail
      CID='${self.triggers.cluster_id}'
      REGION='${var.region}'
      aws redshift wait cluster-available --cluster-identifier "$CID" --region "$REGION"
      STATUS=$(aws redshift describe-clusters --cluster-identifier "$CID" --region "$REGION" \
        --query 'Clusters[0].AvailabilityZoneRelocationStatus' --output text | tr -d '\r\n')
      if [ "$STATUS" != "disabled" ]; then
        aws redshift modify-cluster --cluster-identifier "$CID" --no-availability-zone-relocation --region "$REGION"
        aws redshift wait cluster-available --cluster-identifier "$CID" --region "$REGION"
      fi
      aws redshift describe-clusters --cluster-identifier "$CID" --region "$REGION" \
        --query 'Clusters[0].AvailabilityZoneRelocationStatus' --output text
    EOT
    , "\r", "")
  }
}

resource "aws_redshift_parameter_group" "this" {
  name     = module.naming.resource_prefix.redshift_parameter_group
  family   = "redshift-1.0"
  provider = aws.provider2

  parameter {
    name  = "enable_user_activity_logging"
    value = "false"
  }

  parameter {
    name  = "require_ssl"
    value = "false"
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}
