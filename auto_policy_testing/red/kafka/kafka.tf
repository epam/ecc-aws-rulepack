# Takes about 40 min to deploy

resource "aws_msk_cluster" "this" {
  provider               = aws.provider2
  cluster_name           = "${module.naming.resource_prefix.kafka}"
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 2
  
  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster = true
    }
  }

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    client_subnets = [
      data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
      data.terraform_remote_state.common.outputs.vpc_subnet_2_id
    ]
    storage_info {
      ebs_storage_info {
        volume_size = 1
      }
    }
    security_groups = [data.terraform_remote_state.common.outputs.sg_1_id]
  }
}
