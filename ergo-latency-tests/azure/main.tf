resource "aviatrix_account" "azure" {
  account_name        = var.azure_account_name
  cloud_type          = 8
  arm_subscription_id = var.azure_subscription_id
  arm_directory_id    = var.azure_directory_id
  arm_application_id  = var.azure_application_id
  arm_application_key = var.azure_application_key
}

module "trans_eu" {
  source                 = "terraform-aviatrix-modules/azure-transit/aviatrix"
  version                = "4.0.0"
  cidr                   = "10.0.0.0/23"
  region                 = var.eu_region
  account                = aviatrix_account.azure.account_name
  name                   = "trans-azure-eu"
  prefix                 = false
  suffix                 = false
  ha_gw                  = false
}

module "spoke1_eu" {
  source  = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version = "4.0.0"

  name            = "spoke1-azure-eu"
  cidr            = "10.0.2.0/24"
  region          = var.eu_region
  account         = aviatrix_account.azure.account_name
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
  account                = aviatrix_account.azure.account_name
  name                   = "trans-azure-in"
  prefix                 = false
  suffix                 = false
  ha_gw                  = false
}

module "spoke1_in" {
  source  = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version = "4.0.0"

  name            = "spoke1-azure-in"
  cidr            = "10.1.2.0/24"
  region          = var.in_region
  account         = aviatrix_account.azure.account_name
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
