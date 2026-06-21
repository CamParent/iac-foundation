output "appgw_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "appgw_name" {
  description = "Name of the Application Gateway"
  value       = azurerm_application_gateway.this.name
}

output "appgw_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw.ip_address
}

output "appgw_backend_pool_id" {
  description = "ID of the backend address pool"
  value       = tolist(azurerm_application_gateway.this.backend_address_pool)[0].id
}