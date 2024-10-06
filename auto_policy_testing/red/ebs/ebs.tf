# ecc-aws-147-ebs_volume_without_encrypt
# ecc-aws-570-ebs_volumes_are_of_type_gp3_instead_of_io1
resource "aws_ebs_volume" "this" {
  availability_zone = data.aws_availability_zones.this.names[0]
  size              = 4
  type              = "io1"
  iops              = 100

  tags = {
    Name = "${module.naming.resource_prefix.ebs_volume}"
  }
}


# ecc-aws-076-ebs_snapshots_not_publicly_restorable
# ecc-aws-326-ebs_volume_encrypted_with_kms_cmk
# ecc-aws-328-unused_ebs_volumes
# ecc-aws-548-ebs_volumes_are_of_type_gp3_instead_of_gp2
# ecc-aws-379-ebs_snapshot_without_tag_information
# ecc-aws-378-ebs_without_tag_information
resource "aws_ebs_volume" "default_volume" {
  availability_zone = data.aws_availability_zones.this.names[0]
  size              = 8
  type              = "gp2"
  provider          = aws.provider2
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.default_volume.id
  provider  = aws.provider2
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command     = "aws ec2 modify-snapshot-attribute --snapshot-id ${aws_ebs_snapshot.this.id} --attribute createVolumePermission --operation-type add  --group-names all"
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [aws_ebs_snapshot.this]
}


# ecc-aws-575-ebs_volumes_attached_to_stopped_ec2_instances
resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.this.ids[0]

  tags = {
    Name = "${module.naming.resource_prefix.ec2_instance}"
  }
}

resource "aws_ec2_instance_state" "this" {
  instance_id = aws_instance.this.id
  state       = "stopped"
}
