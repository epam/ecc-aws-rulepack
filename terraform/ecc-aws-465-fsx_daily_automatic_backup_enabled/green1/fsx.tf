# resource creation may take about 30 minutes
resource "aws_fsx_ontap_file_system" "this" {
  storage_capacity                = 1024
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  deployment_type                 = "SINGLE_AZ_1"
  storage_type                    = "HDD"
  automatic_backup_retention_days = 10
  throughput_capacity             = 128
  preferred_subnet_id             = data.aws_subnets.this.ids[0]

  tags = {
    Name = "465_fsx_ontap_file_system_green1"
  }
}

# resource creation may take about 30 minutes
resource "aws_directory_service_directory" "this" {
  name     = "workspaces.example.com"
  password = "#S1ncerely"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = data.aws_vpc.default.id
    subnet_ids = [data.aws_subnets.this.ids[0], data.aws_subnets.this.ids[1]]
  }
}

# resource creation may take about 30 minutes
resource "aws_fsx_windows_file_system" "this" {
  active_directory_id             = aws_directory_service_directory.this.id
  storage_type                    = "HDD"
  storage_capacity                = 2000
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  throughput_capacity             = 8
  automatic_backup_retention_days = 10
  skip_final_backup               = true
  deployment_type                 = "SINGLE_AZ_2"

  depends_on = [aws_directory_service_directory.this]

  tags = {
    Name = "465_fsx_windows_file_system_green1"
  }
}