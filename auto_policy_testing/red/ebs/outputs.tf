output "ebs" {
  value = {
    ebs                                                       = aws_ebs_volume.default_volume.id
    ebs-snapshot                                              = aws_ebs_snapshot.this.id
    ecc-aws-570-ebs_volumes_are_of_type_gp3_instead_of_io1    = aws_ebs_volume.this.id
    ecc-aws-147-ebs_volume_without_encrypt                    = aws_ebs_volume.this.id
    ecc-aws-575-ebs_volumes_attached_to_stopped_ec2_instances = aws_instance.this.root_block_device.0.volume_id
  }
}
