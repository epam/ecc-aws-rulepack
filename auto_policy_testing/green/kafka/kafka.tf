resource "aws_vpc" "this" {
  cidr_block = "192.168.0.0/22"
}

resource "aws_subnet" "subnet_1" {
  availability_zone = data.aws_availability_zones.this.names[0]
  cidr_block        = "192.168.0.0/24"
  vpc_id            = aws_vpc.this.id
}

resource "aws_subnet" "subnet_2" {
  availability_zone = data.aws_availability_zones.this.names[1]
  cidr_block        = "192.168.1.0/24"
  vpc_id            = aws_vpc.this.id
}

resource "aws_subnet" "subnet_3" {
  availability_zone = data.aws_availability_zones.this.names[2]
  cidr_block        = "192.168.2.0/24"
  vpc_id            = aws_vpc.this.id
}

resource "aws_security_group" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_msk_cluster" "this" {
  cluster_name           = "347-msk-cluster-green"
  kafka_version          = "2.6.2"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    client_subnets = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id,
      aws_subnet.subnet_3.id,
    ]
    storage_info {
      ebs_storage_info {
        volume_size = 5
      }
    }
    security_groups = [aws_security_group.this.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = data.terraform_remote_state.common.outputs.kms_key_arn
    
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster = true
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.this.name
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${module.naming.resource_prefix.kafka}"
}

# resource "aws_fsx_lustre_file_system" "this" {
#   storage_capacity                = 6000
#   subnet_ids                      = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
#   kms_key_id                      = data.terraform_remote_state.common.outputs.kms_key_arn
#   automatic_backup_retention_days = 7
#   deployment_type                 = "PERSISTENT_1"
#   storage_type                    = "HDD"
#   drive_cache_type                = "NONE"
#   per_unit_storage_throughput     = 12
#   copy_tags_to_backups            = true

#   log_configuration {
#     level       = "WARN_ERROR"
#     destination = aws_cloudwatch_log_group.this.arn
#   }
# }

# resource "aws_cloudwatch_log_group" "this" {
#   name = "/aws/fsx/${module.naming.resource_prefix.fsx}"
# }

# resource "aws_fsx_backup" "this" {
#   file_system_id = aws_fsx_lustre_file_system.this.id
# }

# # ecc-aws-467-fsx_windows_file_server_multi_az_enabled
# # resource creation may take about 30 minutes
# resource "aws_directory_service_directory" "this" {
#   name     = "workspaces.example.com"
#   password = "#S1ncerely"
#   edition  = "Standard"
#   type     = "MicrosoftAD"

#   vpc_settings {
#     vpc_id     = data.aws_vpc.default.id
#     subnet_ids = [data.aws_subnets.this.ids[0], data.aws_subnets.this.ids[1]]
#   }
# }

# resource "aws_fsx_windows_file_system" "this" {
#   active_directory_id             = aws_directory_service_directory.this.id
#   storage_type                    = "HDD"
#   storage_capacity                = 2000
#   subnet_ids                      = [data.aws_subnets.this.ids[0],data.aws_subnets.this.ids[1]]
#   throughput_capacity             = 8
#   skip_final_backup               = true
#   deployment_type                 = "MULTI_AZ_1"
#   preferred_subnet_id             = data.aws_subnets.this.ids[0]

#   depends_on = [aws_directory_service_directory.this]
# }