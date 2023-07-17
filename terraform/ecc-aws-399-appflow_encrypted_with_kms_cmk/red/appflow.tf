resource "aws_appflow_flow" "this" {
  name = "399-appflow-red"

  source_flow_config {
    connector_type = "S3"
    source_connector_properties {
      s3 {
        bucket_name   = aws_s3_bucket.this.bucket
        bucket_prefix = "source"
      }
    }
  }

  destination_flow_config {
    connector_type = "S3"
    destination_connector_properties {
      s3 {
        bucket_name = aws_s3_bucket.this.bucket
        bucket_prefix = "destination"

        s3_output_format_config {
          file_type = "JSON"
        }
      }
    }
  }

  task {
    source_fields     = ["title1"]
    task_type         = "Map"
    destination_field = "title1"
    connector_operator {
      s3 = "NO_OP"
    }

  }

  trigger_config {
    trigger_type = "OnDemand"
  }

  depends_on = [
    aws_s3_bucket_acl.this, aws_s3_bucket_policy.this
  ]
}