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
  description = "Resource group to deploy App Gateway into"
  type        = string
}

variable "appgw_subnet_id" {
  description = "Subnet ID for the App Gateway - must be dedicated subnet"
  type        = string
}

variable "backend_fqdns" {
  description = "List of backend FQDNs or IPs"
  type        = list(string)
  default     = ["10.1.0.10"]
}

variable "waf_mode" {
  description = "WAF mode - Detection or Prevention"
  type        = string
  default     = "Detection"

  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_mode)
    error_message = "WAF mode must be either Detection or Prevention."
  }
}

variable "sku_capacity" {
  description = "Number of App Gateway instances"
  type        = number
  default     = 1
}