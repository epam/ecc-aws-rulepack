resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 10
}

resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command     = "aws ec2 modify-snapshot-attribute --snapshot-id ${aws_ebs_snapshot.this.id} --attribute createVolumePermission --operation-type add  --group-names all"
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [aws_ebs_snapshot.this]
}