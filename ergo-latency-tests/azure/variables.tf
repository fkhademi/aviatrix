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
  default = "West Europe"
}

variable "in_region" { 
  default = "West India"
}

#Contoller access accounts
variable "azure_account_name" {
  default = "AZURE"
}

#CSP Accounts
variable "azure_subscription_id" {
  type    = string
}

variable "azure_directory_id" {
  type    = string
}

variable "azure_application_id" {
  type    = string
}

variable "azure_application_key" {
  type    = string
}