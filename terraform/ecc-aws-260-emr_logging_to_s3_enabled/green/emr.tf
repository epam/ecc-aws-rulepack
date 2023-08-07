resource "aws_emr_cluster" "this" {
  name                              = "260_emr_cluster_green"
  release_label                     = "emr-5.33.0"
  applications                      = ["Spark"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  ebs_root_volume_size              = 10
  log_uri                           = "s3://${aws_s3_bucket.this.id}/"

  ec2_attributes {
    subnet_id                         = aws_subnet.this.id
    emr_managed_master_security_group = aws_security_group.this.id
    emr_managed_slave_security_group  = aws_security_group.this.id
    instance_profile                  = aws_iam_instance_profile.this.arn
  }

  master_instance_group {
    name           = "260_master_instance_group_green"
    instance_type  = "m4.large"
    instance_count = 1
  }

  core_instance_group {
    name           = "260_core_instance_group_green"
    instance_count = 1
    instance_type  = "m4.large"
  }

  service_role = aws_iam_role.emr_service_role.arn

  depends_on = [aws_subnet.this, aws_iam_role.emr_service_role, aws_iam_role.emr_ec2_instance_profile, aws_iam_instance_profile.this, aws_s3_bucket_acl.this]
}

resource "aws_s3_bucket" "this" {
  bucket = "260-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}