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

module "aks" {
  source = "../../modules/aks"

  deploy_aks = var.deploy_aks
  location   = var.location

  aks_rg_name      = var.spoke_rg_name
  aks_cluster_name = var.aks_cluster_name
  aks_dns_prefix   = var.aks_dns_prefix

  spoke_rg_name     = var.spoke_rg_name
  spoke_vnet_name   = var.spoke_vnet_name
  aks_subnet_prefix = var.aks_subnet_prefix

  node_count   = var.aks_node_count
  node_vm_size = var.aks_node_vm_size

  depends_on = [module.spoke_networking]
}
