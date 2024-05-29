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
  cluster_name           = "${module.naming.resource_prefix.kafka}"
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
