# In order to create Green infrastructure, after "terraform apply" was executed, go to EC2 service -> Security Groups. 
# Use a filter to choose the SG only from the created by terraform VPC, then choose the SG that ends to '_controllers'.
# Edit the Source for all inbound rules. Change all "0.0.0.0/32" sources to IP address "10.0.2.1/24".

resource "aws_directory_service_directory" "this" {
  name     = "DirectoryService.example.com"
  password = "#S1ncerely"
  size     = "Small"

  vpc_settings {
    vpc_id     = aws_vpc.this.id
    subnet_ids = [aws_subnet.this1.id, aws_subnet.this2.id]
  }
}