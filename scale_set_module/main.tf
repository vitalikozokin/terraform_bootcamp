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


resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
  location                    = var.resource_group_location
  name                        = var.scale_set_name
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
      subnet_id = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.backend_pool_id]
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
  location            = var.resource_group_location
  name                = "scale-monitor"
  resource_group_name = var.resource_group_name
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