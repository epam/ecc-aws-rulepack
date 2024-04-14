module "naming" {
  source        = "../../shared_tf_modules/naming"
  resource_type = basename(abspath(path.module))
  status        = title(basename(dirname(abspath(path.module))))
}

data "terraform_remote_state" "common" {
  backend = "local"

  config = {
    path = "../common_resources/terraform.tfstate"
  }
}
