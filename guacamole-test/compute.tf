
module "azure_client1" {
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git"

  name            = "client1"
  region          = var.azure_region
  rg              = "privlink-rg"
  vnet            = "privlink-rg-vnet"
  subnet          = "/subscriptions/cd0efb1b-7b12-46e5-b53a-c394d8f9b923/resourceGroups/rg-av-azure-client-node-026780/providers/Microsoft.Network/virtualNetworks/azure-client-node/subnets/azure-client-node-Public-gateway-subnet-1"
  ssh_key         = var.ssh_key
  cloud_init_data = data.template_cloudinit_config.config.rendered
  public_ip       = true
}

module "azure_client2" {
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git"

  name            = "client2"
  region          = var.azure_region
  rg              = "privlink-rg"
  vnet            = "privlink-rg-vnet"
  subnet          = "/subscriptions/cd0efb1b-7b12-46e5-b53a-c394d8f9b923/resourceGroups/rg-av-azure-client-node-026780/providers/Microsoft.Network/virtualNetworks/azure-client-node/subnets/azure-client-node-Public-gateway-subnet-1"
  ssh_key         = var.ssh_key
  cloud_init_data = data.template_cloudinit_config.config.rendered
  public_ip       = true
}

module "azure_client3" {
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git"

  name            = "client3"
  region          = var.azure_region
  rg              = "privlink-rg"
  vnet            = "privlink-rg-vnet"
  subnet          = "/subscriptions/cd0efb1b-7b12-46e5-b53a-c394d8f9b923/resourceGroups/rg-av-azure-client-node-026780/providers/Microsoft.Network/virtualNetworks/azure-client-node/subnets/azure-client-node-Public-gateway-subnet-1"
  ssh_key         = var.ssh_key
  cloud_init_data = data.template_cloudinit_config.config.rendered
  public_ip       = true
}

module "azure_client4" {
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git"

  name            = "client4"
  region          = var.azure_region
  rg              = "privlink-rg"
  vnet            = "privlink-rg-vnet"
  subnet          = "/subscriptions/cd0efb1b-7b12-46e5-b53a-c394d8f9b923/resourceGroups/rg-av-azure-client-node-026780/providers/Microsoft.Network/virtualNetworks/azure-client-node/subnets/azure-client-node-Public-gateway-subnet-1"
  ssh_key         = var.ssh_key
  cloud_init_data = data.template_cloudinit_config.config.rendered
  public_ip       = true
}

module "azure_client5" {
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git"

  name            = "client5"
  region          = var.azure_region
  rg              = "privlink-rg"
  vnet            = "privlink-rg-vnet"
  subnet          = "/subscriptions/cd0efb1b-7b12-46e5-b53a-c394d8f9b923/resourceGroups/rg-av-azure-client-node-026780/providers/Microsoft.Network/virtualNetworks/azure-client-node/subnets/azure-client-node-Public-gateway-subnet-1"
  ssh_key         = var.ssh_key
  cloud_init_data = data.template_cloudinit_config.config.rendered
  public_ip       = true
}

module "azure_client6" {
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git"

  name            = "client6"
  region          = var.azure_region
  rg              = "privlink-rg"
  vnet            = "privlink-rg-vnet"
  subnet          = "/subscriptions/cd0efb1b-7b12-46e5-b53a-c394d8f9b923/resourceGroups/rg-av-azure-client-node-026780/providers/Microsoft.Network/virtualNetworks/azure-client-node/subnets/azure-client-node-Public-gateway-subnet-1"
  ssh_key         = var.ssh_key
  cloud_init_data = data.template_cloudinit_config.config.rendered
  public_ip       = true
}

data "aws_route53_zone" "main" {
  name         = var.dns_zone
  private_zone = false
}

data "template_file" "cloudconfig" {
  template = file("${path.module}/cloud-init-client.tpl")
  vars = {
    username   = "pod"
    password   = "${var.password}"
    hostname   = "client.${var.dns_zone}"
    domainname =  var.dns_zone
    pod_id     = "pod1"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloudconfig.rendered}"
  }
}

resource "aws_route53_record" "client1" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "client1.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azure_client1.public_ip.ip_address]
}
resource "aws_route53_record" "client2" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "client2.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azure_client2.public_ip.ip_address]
}
resource "aws_route53_record" "client3" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "client3.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azure_client3.public_ip.ip_address]
}
resource "aws_route53_record" "client4" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "client4.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azure_client4.public_ip.ip_address]
}
resource "aws_route53_record" "client5" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "client5.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azure_client5.public_ip.ip_address]
}
resource "aws_route53_record" "client6" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "client6.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azure_client6.public_ip.ip_address]
}
