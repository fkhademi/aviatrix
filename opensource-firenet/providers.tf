provider "aviatrix" {
  controller_ip           = "ctrl.avxlab.de"
  username                = "admin"
  password                = var.aviatrix_admin_password
  skip_version_validation = true
  version                 = ">2.16.0"
}
provider "aws" {
  region = var.region
}