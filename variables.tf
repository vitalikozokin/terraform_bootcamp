variable "resource_group_name" {
  description = "name of the resource group"
  default = "bootcamp"
}

variable "resource_group_location" {
  description = "location of the resource group"
  default = "canadacentral"
}

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



