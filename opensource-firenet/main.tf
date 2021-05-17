module "firenet" {
  source  = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version = "3.0.1"

  cidr                   = "10.0.0.0/23"
  region                 = var.region
  account                = var.aws_acct_name
  ha_gw                  = false
  enable_transit_firenet = true
  instance_size          = "c5.xlarge"
}

data "aws_subnet_ids" "subnet" {
  vpc_id = module.firenet.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*-dmz-firewall"]
  }
}

module "fw" {
  source = "git::https://github.com/fkhademi/terraform-aws-instance-module.git"

  name          = "fw-vm"
  region        = var.region
  vpc_id        = module.firenet.vpc.vpc_id
  subnet_id     = module.firenet.vpc.subnets[5].subnet_id
  ssh_key       = var.ssh_key
  public_ip     = true
  instance_size = "t3.small"
}

resource "aws_network_interface" "lan" {
  subnet_id         = element(tolist(data.aws_subnet_ids.subnet.ids), 0)
  security_groups   = [module.fw.sg.id]
  source_dest_check = false

  attachment {
    instance     = module.fw.vm.id
    device_index = 1
  }
}

/* resource "aws_network_interface" "wan" {
  subnet_id         = element(tolist(data.aws_subnet_ids.subnet.ids), 0)
  security_groups   = [module.fw.sg.id]
  source_dest_check = false

  attachment {
    instance     = module.fw.vm.id
    device_index = 1
  }
} */

resource "aviatrix_firewall_instance_association" "fw" {
  vpc_id               = module.firenet.vpc.vpc_id
  firenet_gw_name      = module.firenet.transit_gateway.gw_name
  instance_id          = module.fw.vm.id
  firewall_name        = "fw"
  lan_interface        = aws_network_interface.lan.id
  management_interface = null
  egress_interface     = module.fw.vm.primary_network_interface_id
  attached             = true
}

/* module "fw" {
  source = "git::https://github.com/fkhademi/terraform-aws-instance-module.git"

  name          = "fw-vm"
  region        = var.region
  vpc_id        = aviatrix_vpc.default.
  subnet_id     = module.firenet.vpc.subnets[5].subnet_id
  ssh_key       = var.ssh_key
  public_ip     = true
  instance_size = "t3.small"
}
 */
#Transit VPC
/* resource "aviatrix_vpc" "default" {
  cloud_type           = 1
  name                 = var.env_name
  region               = var.region
  cidr                 = var.cidr
  account_name         = var.aws_acct_name
  aviatrix_firenet_vpc = true
  aviatrix_transit_vpc = false
}

#Transit GW
resource "aviatrix_transit_gateway" "default" {
  enable_active_mesh     = true
  cloud_type             = 1
  vpc_reg                = var.region
  gw_name                = var.env_name
  gw_size                = "c5.xlarge"
  vpc_id                 = aviatrix_vpc.default.vpc_id
  account_name           = var.aws_acct_name
  subnet                 = aviatrix_vpc.default.subnets[0].cidr
  enable_transit_firenet = true
  connected_transit      = true
}
 */
#Firewall instances
/* resource "aviatrix_firewall_instance" "firewall_instance" {
  count                  = var.ha_gw ? 0 : 1
  firewall_name          = "${var.env_name}-fw"
  firewall_size          = var.fw_instance_size
  vpc_id                 = aviatrix_vpc.default.vpc_id
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  egress_subnet          = aviatrix_vpc.default.subnets[1].cidr
  firenet_gw_name        = aviatrix_transit_gateway.default.gw_name
  iam_role               = var.iam_role
  bootstrap_bucket_name  = var.bootstrap_bucket_name
  management_subnet      = local.is_palo ? aviatrix_vpc.default.subnets[0].cidr : ""
}

#Firenet
resource "aviatrix_firenet" "firenet" {
  vpc_id                               = aviatrix_vpc.default.vpc_id
  inspection_enabled                   = var.inspection_enabled
  egress_enabled                       = var.egress_enabled
  keep_alive_via_lan_interface_enabled = var.keep_alive_via_lan_interface_enabled
  manage_firewall_instance_association = false
  depends_on                           = [aviatrix_firewall_instance_association.firenet_instance1, aviatrix_firewall_instance_association.firenet_instance2, aviatrix_firewall_instance_association.firenet_instance]
}

resource "aviatrix_firewall_instance_association" "firenet_instance" {
  count                = var.ha_gw ? 0 : 1
  vpc_id               = aviatrix_vpc.default.vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.default.gw_name
  instance_id          = aviatrix_firewall_instance.firewall_instance[0].instance_id
  firewall_name        = aviatrix_firewall_instance.firewall_instance[0].firewall_name
  lan_interface        = aviatrix_firewall_instance.firewall_instance[0].lan_interface
  management_interface = aviatrix_firewall_instance.firewall_instance[0].management_interface
  egress_interface     = aviatrix_firewall_instance.firewall_instance[0].egress_interface
  attached             = var.attached
}
 */