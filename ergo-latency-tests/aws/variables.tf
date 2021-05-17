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
  default = "eu-central-1"
}

variable "in_region" { 
  default = "ap-south-1"
}

#Contoller access accounts
variable "aws_account_name" {
  default = "AWS"
}

#CSP Accounts
variable "aws_account_number" {
  type    = string
}

variable "aws_access_key" {
  type    = string
}

variable "aws_secret_key" {
  type    = string
}
