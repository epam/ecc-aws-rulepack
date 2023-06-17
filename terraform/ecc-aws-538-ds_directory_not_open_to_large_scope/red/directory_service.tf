
resource "aws_directory_service_directory" "this" {
  name     = "DirectoryService.example.com"
  password = "#S1ncerely"
  size     = "Small"

  vpc_settings {
    vpc_id     = aws_vpc.this.id
    subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
  }
}