variable "deploy_aks" {
  type    = bool
  default = false
}

variable "location" {
  type = string
}

variable "aks_rg_name" {
  type = string
}

variable "aks_cluster_name" {
  type = string
}

variable "aks_dns_prefix" {
  type = string
}

variable "spoke_rg_name" {
  type = string
}

variable "spoke_vnet_name" {
  type = string
}

variable "aks_subnet_prefix" {
  type = string
}

variable "node_count" {
  type    = number
  default = 1
}

variable "node_vm_size" {
  type    = string
  default = "Standard_B2s" # cheap-ish default
}

# AKS subnet inside the spoke VNet
resource "azurerm_subnet" "aks" {
  count = var.deploy_aks ? 1 : 0

  name                 = "${var.aks_cluster_name}-subnet"
  resource_group_name  = var.spoke_rg_name
  virtual_network_name = var.spoke_vnet_name
  address_prefixes     = [var.aks_subnet_prefix]
}

resource "azurerm_kubernetes_cluster" "aks" {
  count = var.deploy_aks ? 1 : 0

  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.aks_rg_name
  dns_prefix          = var.aks_dns_prefix

  kubernetes_version = null # let Azure pick a default

  default_node_pool {
    name            = "system"
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    vnet_subnet_id  = azurerm_subnet.aks[0].id
    type            = "VirtualMachineScaleSets"
    orchestrator_version = null
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.2.0.0/24"
    dns_service_ip     = "10.2.0.10"
  }

  # Simplify for lab: no RBAC addons, etc.
}

output "aks_cluster_name" {
  value       = one(azurerm_kubernetes_cluster.aks[*].name)
  description = "Name of the AKS cluster (if deployed)."
}
