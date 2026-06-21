output "private_endpoint_id" {
  description = "ID of the private endpoint"
  value       = azurerm_private_endpoint.this.id
}

output "private_endpoint_name" {
  description = "Name of the private endpoint"
  value       = azurerm_private_endpoint.this.name
}

output "private_ip_address" {
  description = "Private IP address assigned to the endpoint"
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}

output "private_dns_zone_ids" {
  description = "IDs of any private DNS zones created by this module"
  value       = { for k, v in azurerm_private_dns_zone.this : k => v.id }
}