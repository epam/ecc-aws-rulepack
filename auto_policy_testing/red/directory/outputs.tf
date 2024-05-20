output "directory" {
  value = {
    directory = aws_directory_service_directory.this.id 
  }
}
