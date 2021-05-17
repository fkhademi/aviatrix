#Aviatrix Controller Vars
variable "aviatrix_admin_account" { 
  default = "admin" 
}

variable "aviatrix_admin_password" {
  type = string
}

variable "aviatrix_controller_ip" {
  type = string
}

#Regions
variable "eu_region" {
  default = "europe-west1"
}

variable "in_region" { 
  default = "asia-south1"
}

#Contoller access accounts
variable "gcp_account_name" {
  default = "gcp"
}

#CSP Accounts
variable "gcp_project_id" {
  type    = string
}