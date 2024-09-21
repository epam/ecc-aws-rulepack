module "naming" {
  source        = "../../shared_tf_modules/naming"
  resource_type = basename(abspath(path.module))
  status        = title(basename(dirname(abspath(path.module))))
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key = var.remote_state_key
    region = var.remote_state_region
  }
}

