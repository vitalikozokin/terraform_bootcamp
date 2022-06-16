variable "names" {
  description = "name of server and network interfaces"
  type        = map(any)
  default = {
    web1     = "public"
    web2     = "public"
    web3     = "public"
    database = "private"
  }
}



variable "subnets_security_rules" {
  description = "rules of all security groups"
  type        = map(any)
  default = {
    public_ssh = {
      type                       = "public"
      name                       = "allow SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "109.64.62.253"
      destination_address_prefix = "192.168.1.4"

    }

    allow_port_8080 = {
      type                       = "public"
      name                       = "allow 8080"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.1.0/25"

    }
    private_ssh = {
      type                       = "private"
      name                       = "allow SSH"
      priority                   = 115
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "192.168.1.0/25"
      destination_address_prefix = "192.168.1.132"

    }

    allow_5432 = {
      type                       = "private"
      name                       = "allow 5432"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "5432"
      source_address_prefix      = "192.168.1.0/25"
      destination_address_prefix = "192.168.1.132"

    }

    deny_all = {
      type                       = "private"
      name                       = "deny all ports"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.1.132"
    }
  }
}