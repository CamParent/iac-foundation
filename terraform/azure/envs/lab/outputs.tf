output "hub_vnet_id" {
  description = "ID of the hub VNet"
  value       = module.networking.hub_vnet_id
}

output "hub_vnet_name" {
  description = "Name of the hub VNet"
  value       = module.networking.hub_vnet_name
}

output "spoke_vnet_id" {
  description = "ID of the spoke VNet"
  value       = module.networking.spoke_vnet_id
}

output "spoke_vnet_name" {
  description = "Name of the spoke VNet"
  value       = module.networking.spoke_vnet_name
}

output "appgw_name" {
  description = "Name of the Application Gateway"
  value       = module.appgateway.appgw_name
}

output "appgw_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = module.appgateway.appgw_public_ip
}

output "private_endpoint_name" {
  description = "Name of the private endpoint"
  value       = module.private_endpoint.private_endpoint_name
}

output "private_ip_address" {
  description = "Private IP address of the private endpoint"
  value       = module.private_endpoint.private_ip_address
}