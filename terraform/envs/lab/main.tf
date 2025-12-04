module "networking" {
  source = "../../modules/networking"

  location          = var.location
  hub_rg_name       = var.hub_rg_name
  hub_vnet_name     = var.hub_vnet_name
  hub_address_space = var.hub_address_space
}

module "spoke_networking" {
  source = "../../modules/spoke-networking"

  location = var.location

  spoke_rg_name       = var.spoke_rg_name
  spoke_vnet_name     = var.spoke_vnet_name
  spoke_address_space = var.spoke_address_space

  hub_rg_name   = var.hub_rg_name
  hub_vnet_name = var.hub_vnet_name
  hub_vnet_id   = module.networking.hub_vnet_id
}
