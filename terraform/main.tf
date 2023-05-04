provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret

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
  application_type = "PIP"
}

module "network" {
  source           = ".//modules/network"
  location         = var.location
  resource_group   = var.resource_group
  application_type = "NTW"

  subnet_id                 = module.network.network_id
  public_ip_address_id      = module.publicip.pip_id
  network_security_group_id = module.nsg.nsg_id
}

module "virtual_machine" {
  source           = ".//modules/vm"
  location         = var.location
  resource_group   = var.resource_group
  application_type = "VM"

  network_interface_ids = module.network.network_interface_id
  password              = var.password
}

module "nsg" {
  source           = ".//modules/networksecuritygroup"
  location         = var.location
  resource_group   = var.resource_group
  application_type = "NSG"
  subnet_id        = module.network.subnet_id
}

module "appservice" {
  source           = ".//modules/appservice"
  location         = var.location
  resource_group   = var.resource_group
  application_type = "APP"
}


resource "null_resource" "test-remote-exec-1" {
  connection {
    type     = "ssh"
    user     = "sami"
    password = var.password
    host     = module.publicip.ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "echo Miarahaba anilay tafiditra",
      "sudo apt-get update",
      "sudo apt-get -y install zip",
      "sudo apt-get -y install azure-cli",
      "curl -O https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz",
      "mkdir myagent && cd myagent",
      "tar zxvf ../vsts-agent-linux-x64-3.218.0.tar.gz"
    ]

  }
}
