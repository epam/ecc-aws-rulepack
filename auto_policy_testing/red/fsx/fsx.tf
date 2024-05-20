resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity                = 6000
  subnet_ids                      = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  automatic_backup_retention_days = 5
  deployment_type                 = "PERSISTENT_1"
  storage_type                    = "HDD"
  drive_cache_type                = "NONE"
  per_unit_storage_throughput     = 12
  provider                        = aws.provider2

  tags = {
    Name = "${module.naming.resource_prefix.fsx}-lustre"
  }
}

resource "aws_fsx_backup" "this" {
  file_system_id = aws_fsx_lustre_file_system.this.id
  provider       = aws.provider2
}

# resource creation may take about 30 minutes
resource "aws_directory_service_directory" "this" {
  name     = "${module.naming.resource_prefix.directory}.com"
  password = "#S1ncerely"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = data.terraform_remote_state.common.outputs.vpc_id
    subnet_ids = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
  }
}

resource "aws_fsx_windows_file_system" "this" {
  active_directory_id = aws_directory_service_directory.this.id
  storage_type        = "HDD"
  storage_capacity    = 2000
  subnet_ids          = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  throughput_capacity = 8
  skip_final_backup   = true
  deployment_type     = "SINGLE_AZ_2"

  tags = {
    Name = "${module.naming.resource_prefix.fsx}-win"
  }

  depends_on = [aws_directory_service_directory.this]
}

resource "aws_fsx_openzfs_file_system" "this" {
  storage_capacity    = 64
  subnet_ids          = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
  deployment_type     = "SINGLE_AZ_1"
  throughput_capacity = 64
  skip_final_backup   = true

  tags = {
    Name = "${module.naming.resource_prefix.fsx}-openzfs"
  }
}

# resource creation may take about 30 minutes
resource "aws_fsx_ontap_file_system" "this" {
  storage_capacity    = 1024
  subnet_ids          = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]
  deployment_type     = "MULTI_AZ_1"
  storage_type        = "HDD"
  throughput_capacity = 128
  preferred_subnet_id = data.terraform_remote_state.common.outputs.vpc_subnet_1_id

  tags = {
    Name = "${module.naming.resource_prefix.fsx}-ontap"
  }
}