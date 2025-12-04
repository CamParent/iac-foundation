variable "location" {
  type    = string
  default = "eastus2"
}

variable "hub_rg_name" {
  type    = string
  default = "rg-hub-networking-tf"
}

variable "hub_vnet_name" {
  type    = string
  default = "vnet-hub-01-tf"
}

variable "hub_address_space" {
  type    = list(string)
  default = ["10.11.0.0/16"]
}

module "networking" {
  source = "../../modules/networking"

  location         = var.location
  hub_rg_name      = var.hub_rg_name
  hub_vnet_name    = var.hub_vnet_name
  hub_address_space = var.hub_address_space
}
