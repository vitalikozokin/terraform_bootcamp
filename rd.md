## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.0.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.backend_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_lb_rule.web](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.backend_assosiat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_security_group.security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.security_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.assosiat_to_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_id.randomId](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_names"></a> [names](#input\_names) | name of server and network interfaces | `map(any)` | <pre>{<br>  "database": "private",<br>  "web1": "public",<br>  "web2": "public",<br>  "web3": "public"<br>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | map of subnets of the network | `map(any)` | <pre>{<br>  "private": "192.168.1.128/25",<br>  "public": "192.168.1.0/25"<br>}</pre> | no |
| <a name="input_subnets_security_rules"></a> [subnets\_security\_rules](#input\_subnets\_security\_rules) | rules of all security groups | `map(any)` | <pre>{<br>  "allow_5432": {<br>    "access": "Allow",<br>    "destination_address_prefix": "192.168.1.132",<br>    "destination_port_range": "5432",<br>    "direction": "Inbound",<br>    "name": "allow 5432",<br>    "priority": 110,<br>    "protocol": "*",<br>    "source_address_prefix": "192.168.1.0/25",<br>    "source_port_range": "5432",<br>    "type": "private"<br>  },<br>  "allow_port_8080": {<br>    "access": "Allow",<br>    "destination_address_prefix": "192.168.1.0/25",<br>    "destination_port_range": "8080",<br>    "direction": "Inbound",<br>    "name": "allow 8080",<br>    "priority": 110,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_port_range": "8080",<br>    "type": "public"<br>  },<br>  "deny_all": {<br>    "access": "Deny",<br>    "destination_address_prefix": "192.168.1.132",<br>    "destination_port_range": "*",<br>    "direction": "Inbound",<br>    "name": "allow 5432",<br>    "priority": 4096,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*",<br>    "type": "private"<br>  },<br>  "ssh": {<br>    "access": "Allow",<br>    "destination_address_prefix": "192.168.1.4",<br>    "destination_port_range": "22",<br>    "direction": "Inbound",<br>    "name": "allow SSH",<br>    "priority": 110,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_port_range": "22",<br>    "type": "private"<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
