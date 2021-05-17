provider "aviatrix" {
  controller_ip           = var.aviatrix_controller_ip
  username                = var.aviatrix_admin_account
  password                = var.aviatrix_admin_password
  skip_version_validation = false
  version                 = ">2.17.1"
}