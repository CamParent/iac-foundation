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

variable "hub_address_space" {
  description = "Address space for hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "spoke_address_space" {
  description = "Address space for spoke VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "gateway_subnet_prefix" {
  description = "Gateway subnet prefix"
  type        = string
  default     = "10.0.0.0/27"
}

variable "appgw_subnet_prefix" {
  description = "App Gateway subnet prefix"
  type        = string
  default     = "10.0.1.0/24"
}

variable "spoke_subnet_prefix" {
  description = "Spoke workload subnet prefix"
  type        = string
  default     = "10.1.0.0/24"
}