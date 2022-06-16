# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#this module create virtual network details
module "network_details" {
  source = "./network_module"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  vnet_name = "virtual_network"
  network_address = "192.168.1.0/24"
  public_subnet = "192.168.1.0/25"
  private_subnet = "192.168.1.128/25"

}
#this module create public ip and load balancer
module "load_balancer_creation" {
  source = "./lb_module"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  load_balancer_name = "load-balancer"
  sku_type = "Standard"
  backend_pool_name = "backend-pool"
}
#this module create linux virtual machine scale set
module "scale_set" {
  source = "./scale_set_module"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  scale_set_name = "vm_scale_set"
  subnet_id = module.network_details.public_subnet.id
  backend_pool_id = module.load_balancer_creation.loab_balancer_backend_pool.id
}
#this module create postgres service
module "postgres_service" {
  source = "./postgres_service_module"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  dns_zone_name = "postgres.service.postgres.database.azure.com"
  virtual_network_id = module.network_details.virtual_net.id
  private_subnet_id = module.network_details.private_subnet.id
  service_name = "postgres-service"
  username = "postgres"
  password = "P0$tgres2022"
}



