# ecc-aws-022-ebs_volumes_too_old_snapshots
# ecc-aws-076-ebs_snapshots_not_publicly_restorable
# 
# ecc-aws-378-ebs_without_tag_information
# ecc-aws-379-ebs_snapshot_without_tag_information
# ecc-aws-548-ebs_volumes_are_of_type_gp3_instead_of_gp2
resource "aws_ebs_volume" "this" {
  availability_zone = data.aws_availability_zones.this.names[0]
  size              = 8
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "${module.naming.resource_prefix.ebs_volume}"
  }
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id

  tags = {
    Name = "${module.naming.resource_prefix.ebs_snapshot}"
  }
}

resource "aws_ebs_volume" "volume_encrypted_with_kms_cmk" {
  availability_zone = data.aws_availability_zones.this.names[0]
  size              = 5
  encrypted         = true
  kms_key_id        = data.terraform_remote_state.common.outputs.kms_key_arn

  tags = {
    Name = "${module.naming.resource_prefix.ebs_volume}"
  }
}

# ecc-aws-328-unused_ebs_volumes
resource "aws_instance" "ec2_instance_to_test_unused_ebs_volumes" {
  ami               = data.aws_ami.this.id
  instance_type     = "t2.nano"
  availability_zone = data.aws_availability_zones.this.names[0]

  tags = {
    Name = "${module.naming.resource_prefix.ec2_instance}"
  }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.ec2_instance_to_test_unused_ebs_volumes.id
}