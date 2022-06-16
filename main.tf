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


module "network_details" {
  source = "./network_module"
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  vnet_name = "virtual_network"
  network_address = "192.168.1.0/25"
  public_subnet = "192.168.1.0/25"
  private_subnet = "192.168.1.0.25"

}

module "load_balancer_creation" {
  source = "./lb_module"
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  load_balancer_name = "load-balancer"
  sku_type = "Standard"
  backend_pool_name = "backend-pool"
}


//resource "azurerm_network_security_group" "security_group" {
//  for_each            = var.subnets
//  name                = each.key
//  location            = azurerm_resource_group.rg.location
//  resource_group_name = azurerm_resource_group.rg.name
//}
//
//
//
//resource "azurerm_virtual_network" "vnet" {
//  name                = "virtual_network"
//  address_space       = ["192.168.1.0/24"]
//  location            = azurerm_resource_group.rg.location
//  resource_group_name = azurerm_resource_group.rg.name
//}
//
//resource "azurerm_subnet" "subnet_public" {
//  name                 = "public"
//  resource_group_name  = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet.name
//  address_prefixes     = ["192.168.1.0/25"]
//
//
//}
//
//resource "azurerm_subnet" "subnet_private" {
//  name                 = "private"
//  resource_group_name  = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet.name
//  address_prefixes     = ["192.168.1.128/25"]
//
//  delegation {
//    name = "fs"
//    service_delegation {
//      name = "Microsoft.DBforPostgreSQL/flexibleServers"
//      actions = [
//        "Microsoft.Network/virtualNetworks/subnets/join/action",
//      ]
//    }
//  }
//}
//
//
//resource "azurerm_subnet_network_security_group_association" "assosiate_to_subnet_public" {
//
//  subnet_id                 = azurerm_subnet.subnet_public.id
//  network_security_group_id = azurerm_network_security_group.security_group["public"].id
//}
//
//resource "azurerm_subnet_network_security_group_association" "assosiate_to_subnet_private" {
//
//  subnet_id                 = azurerm_subnet.subnet_private.id
//  network_security_group_id = azurerm_network_security_group.security_group["private"].id
//}


resource "random_id" "randomId" {
  keepers = {
    resource_group = var.resource_group_name
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

//resource "azurerm_public_ip" "public_ip" {
//  name                = "public-lb-ip"
//  resource_group_name =
//  location            = azurerm_resource_group.rg.location
//  allocation_method   = "Static"
//  sku = "Standard"
//}
//
//resource "azurerm_lb" "load_balancer" {
//  name                = "load-balancer"
//  location            = azurerm_resource_group.rg.location
//  resource_group_name = azurerm_resource_group.rg.name
//  sku = "Standard"
//
//  frontend_ip_configuration {
//    name                 = "public-ip-address"
//    public_ip_address_id = azurerm_public_ip.public_ip.id
//  }
//}
//
//resource "azurerm_lb_backend_address_pool" "backend_pool" {
//  loadbalancer_id = azurerm_lb.load_balancer.id
//  name            = "backend-pool"
//
//}
//
//
//resource "azurerm_lb_probe" "load_balancer" {
//  loadbalancer_id = azurerm_lb.load_balancer.id
//  name            = "ssh-running-probe"
//  port            = 8080
//
//}


//resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
//  name                            = "vm-scale-set"
//  resource_group_name             = azurerm_resource_group.rg.name
//  location                        = azurerm_resource_group.rg.location
//  sku                             = "Standard_F2"
//  instances                       = 1
//  admin_username                  = "ubuntu"
//  admin_password                  = "P@$$w0rd2022"
//  disable_password_authentication = false
//
//  source_image_reference {
//    publisher = "Canonical"
//    offer     = "UbuntuServer"
//    sku       = "18.04-LTS"
//    version   = "latest"
//  }
//
//  network_interface {
//    name    = "vmss-interface"
//    primary = true
//
//    ip_configuration {
//      name      = "public"
//      primary   = true
//      subnet_id = azurerm_subnet.subnet["public"].id
//      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
//    }
//  }
//
//  os_disk {
//    storage_account_type = "Standard_LRS"
//    caching              = "ReadWrite"
//  }
//}

resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
  location                    = var.resource_group_location
  name                        = "vm-scale-set"
  platform_fault_domain_count = 1
  resource_group_name         = var.resource_group_name
  sku_name                    = "Standard_DS1_v2"
  instances                   = 1


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name = "vmss-interface"
    primary = true

    ip_configuration {
      name = "ip-configs"
      primary = true
      subnet_id = module.network_details.public_subnet.id
      load_balancer_backend_address_pool_ids = [
        module.load_balancer_creation.loab_balancer_backend_pool.id]
    }
  }
  os_profile {
    linux_configuration {
      computer_name_prefix = "web"
      admin_username       = "ubuntu"
      admin_password       = "P@$$w0rd2022"
      disable_password_authentication = false

    }
  }

}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  location            = azurerm_resource_group.rg.location
  name                = "scale-monitor"
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
  profile {
    name = "auto-scale"
    capacity {
      default = 1
      minimum = 1
      maximum = 5

    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 85
        time_aggregation   = "Average"
        time_grain         = "PT10M"
        time_window        = "PT15M"
      }
      scale_action {
        cooldown  = "PT10M"
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
        operator           = "LessThan"
        statistic          = "Average"
        threshold          = 85
        time_aggregation   = "Average"
        time_grain         = "PT10M"
        time_window        = "PT15M"
      }
      scale_action {
        cooldown  = "PT10M"
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
      }
    }
  }
}


//resource "azurerm_network_security_rule" "security_rules" {
//  for_each = var.subnets_security_rules
//  name                        = each.value.name
//  priority                    = each.value.priority
//  direction                   = each.value.direction
//  access                      = each.value.access
//  protocol                    = each.value.protocol
//  source_port_range           = each.value.source_port_range
//  destination_port_range      = each.value.destination_port_range
//  source_address_prefix       = each.value.source_address_prefix
//  destination_address_prefix  = each.value.destination_address_prefix
//  resource_group_name         = azurerm_resource_group.rg.name
//  network_security_group_name = azurerm_network_security_group.security_group[each.value.type].name
//
//}


resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "postgres.service.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_private_dns_zone_virtual_network_link" "postgres_zone" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}


resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                   = "postgres-sql-service"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "12"
  delegated_subnet_id    = azurerm_subnet.subnet_private.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres_dns.id
  administrator_login    = "postgres"
  administrator_password = "P0$tgres1106"
  zone                   = "1"

  storage_mb = 32768

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres_zone]

}



