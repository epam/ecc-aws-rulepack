output "ami" {
  value = {
    ami = aws_ami.this.id
  }
}
