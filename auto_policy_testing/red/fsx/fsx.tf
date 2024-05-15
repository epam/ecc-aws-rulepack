resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity                = 6000
  subnet_ids                      = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  automatic_backup_retention_days = 5
  deployment_type                 = "PERSISTENT_1"
  storage_type                    = "HDD"
  drive_cache_type                = "NONE"
  per_unit_storage_throughput     = 12
  copy_tags_to_backups            = true
  provider                        = aws.provider2
}

resource "aws_fsx_backup" "this" {
  file_system_id = aws_fsx_lustre_file_system.this.id
  provider       = aws.provider2
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

resource "aws_fsx_windows_file_system" "this" {
  active_directory_id             = aws_directory_service_directory.this.id
  storage_type                    = "HDD"
  storage_capacity                = 2000
  subnet_ids                      = [data.aws_subnets.this.ids[0]]
  throughput_capacity             = 8
  skip_final_backup               = true
  deployment_type                 = "SINGLE_AZ_2"

  depends_on = [aws_directory_service_directory.this]
}
