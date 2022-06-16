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

resource "azurerm_public_ip" "public_ip" {
  name                = "public-lb-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku = var.sku_type
}

resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku = var.sku_type

  frontend_ip_configuration {
    name                 = "public-ip-address"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = var.backend_pool_name

}


resource "azurerm_lb_probe" "load_balancer" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "ssh-running-probe"
  port            = 8080

}