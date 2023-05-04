provider "azurerm" {
  features {}

}
/*
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = random_pet.rg_name.id
}
*/
module "publicip" {
  source           = ".//modules/publicip"
  location         = var.location
  resource_group   = var.resource_group
  resource_type    = "PUBIP"
  application_type = var.application_type
}

module "network" {
  source           = ".//modules/network"
  location         = var.location
  resource_group   = var.resource_group
  resource_type    = "NTW"
  application_type = var.application_type

  subnet_id                 = module.network.network_id
  public_ip_address_id      = module.publicip.pip_id
  network_security_group_id = module.nsg.nsg_id
}

module "virtual_machine" {
  source           = ".//modules/vm"
  location         = var.location
  resource_group   = var.resource_group
  resource_type    = "VM"
  application_type = var.application_type

  network_interface_ids = module.network.network_interface_id
  password              = var.password
}

module "nsg" {
  source           = ".//modules/networksecuritygroup"
  location         = var.location
  resource_group   = var.resource_group
  resource_type    = "NSG"
  application_type = var.application_type

  subnet_id = module.network.subnet_id
}

module "appservice" {
  source           = ".//modules/appservice"
  location         = var.location
  resource_group   = var.resource_group
  application_type = var.application_type
  resource_type    = "APP"
}
