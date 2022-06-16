variable "resource_group_location" {
  description = "location of resource group that contain the network resources"
  type = string
}

variable "resource_group_name" {
  description = "name of resource group that contain the network resources"
  type = string
}

variable "subnet_id" {
  description = "id of subnet that associated to scale set"
  type = string
}

variable "backend_pool_id" {
  description = "backend pool id associated to scale set"
  type = string
}

variable "scale_set_name" {
  description = "name of the scale set"
  type = string
}