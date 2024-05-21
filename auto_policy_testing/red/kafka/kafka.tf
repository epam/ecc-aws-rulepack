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
  provider               = aws.provider2

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster = true
    }
  }

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
}
