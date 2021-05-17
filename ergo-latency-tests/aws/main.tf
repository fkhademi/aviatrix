resource "aviatrix_account" "aws_account" {
  account_name       = var.aws_account_name
  cloud_type         = 1
  aws_iam            = false
  aws_account_number = var.aws_account_number
  aws_access_key     = var.aws_access_key
  aws_secret_key     = var.aws_secret_key
}

module "trans_eu" {
  source                 = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version                = "4.0.0"
  cidr                   = "10.0.0.0/23"
  region                 = var.eu_region
  account                = aviatrix_account.aws_account.account_name
  name                   = "trans-aws-fra"
  prefix                 = false
  suffix                 = false
  ha_gw                  = false
}

module "spoke1_eu" {
  source  = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version = "4.0.0"

  name            = "spoke1-aws-fra"
  cidr            = "10.0.2.0/24"
  region          = var.eu_region
  account         = aviatrix_account.aws_account.account_name
  transit_gw      = module.trans_eu.transit_gateway.gw_name
  prefix          = false
  suffix          = false
  ha_gw           = false
}

module "trans_in" {
  source                 = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version                = "4.0.0"
  cidr                   = "10.1.0.0/23"
  region                 = var.in_region
  account                = aviatrix_account.aws_account.account_name
  name                   = "trans-aws-in"
  prefix                 = false
  suffix                 = false
  ha_gw                  = false
}

module "spoke1_in" {
  source  = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version = "4.0.0"

  name            = "spoke1-aws-in"
  cidr            = "10.1.2.0/24"
  region          = var.in_region
  account         = aviatrix_account.aws_account.account_name
  transit_gw      = module.trans_in.transit_gateway.gw_name
  prefix          = false
  suffix          = false
  ha_gw           = false
}

module "transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.4"

  transit_gateways = [
    module.trans_eu.transit_gateway.gw_name,
    module.trans_in.transit_gateway.gw_name
  ]

}
