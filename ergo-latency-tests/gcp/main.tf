resource "aviatrix_account" "gcp" {
  account_name                        = var.gcp_account_name
  cloud_type                          = 4
  gcloud_project_id                   = var.gcp_project_id
  gcloud_project_credentials_filepath = "gcp.json"
}

module "trans_eu" {
  source                 = "terraform-aviatrix-modules/gcp-transit/aviatrix"
  version                = "3.0.0"
  cidr                   = "10.0.0.0/23"
  region                 = var.eu_region
  account                = aviatrix_account.gcp.account_name
  name                   = "trans-gcp-eu"
  prefix                 = false
  suffix                 = false
  ha_gw                  = false
}

module "spoke1_eu" {
  source  = "terraform-aviatrix-modules/gcp-spoke/aviatrix"
  version = "3.0.0"

  name            = "spoke1-gcp-eu"
  cidr            = "10.0.2.0/24"
  region          = var.eu_region
  account         = aviatrix_account.gcp.account_name
  transit_gw      = module.trans_eu.transit_gateway.gw_name
  prefix          = false
  suffix          = false
  ha_gw           = false
}

module "trans_in" {
  source                 = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version                = "3.0.0"
  cidr                   = "10.1.0.0/23"
  region                 = var.in_region
  account                = aviatrix_account.gcp.account_name
  name                   = "trans-gcp-in"
  prefix                 = false
  suffix                 = false
  ha_gw                  = false
}

module "spoke1_in" {
  source  = "terraform-aviatrix-modules/gcp-spoke/aviatrix"
  version = "3.0.0"

  name            = "spoke1-gcp-in"
  cidr            = "10.1.2.0/24"
  region          = var.in_region
  account         = aviatrix_account.gcp.account_name
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
