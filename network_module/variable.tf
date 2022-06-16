variable "subnets" {
  description = "map of subnets of the network"
  type        = map(any)
  default = {
    public  = var.public_subnet
    private = var.private_subnet
  }
}

variable "resource_group_location" {
  description = "location of resource group that contain the network resources"
  type = string
}

variable "resource_group_name" {
  description = "name of resource group that contain the network resources"
  type = string
}

variable "vnet_name" {
  description = "virtual network name"
  type = string
}

variable "public_subnet" {
  description = "public subnet mask with prefix, example 192.168.1.0/25 "
  type = string
}

variable "private_subnet" {
  description = "private subnet mask with prefix, example 192.168.1.0/25 "
  type = string
}