module "naming" {
  source        = "../../shared_tf_modules/naming"
  resource_type = basename(abspath(path.module))
  status        = title(basename(dirname(abspath(path.module))))
}