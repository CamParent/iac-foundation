variable "location"         { type = string }
variable "hub_rg_name"      { type = string }
variable "hub_vnet_name"    { type = string }
variable "hub_address_space"{
  type = list(string)
}

resource "azurerm_resource_group" "hub" {
  name     = var.hub_rg_name
  location = var.location
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = var.hub_address_space
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}
