variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy private endpoint into"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to deploy private endpoint into"
  type        = string
}

variable "private_connection_resource_id" {
  description = "Resource ID of the service to connect to privately"
  type        = string
}

variable "subresource_names" {
  description = "Subresource names for the private endpoint e.g. sqlServer, blob, vault"
  type        = list(string)
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs to associate with the endpoint"
  type        = list(string)
  default     = []
}

variable "service_name" {
  description = "Short name for the service being connected e.g. sql, storage, keyvault"
  type        = string
}