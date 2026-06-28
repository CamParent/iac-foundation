variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "cam"
}

variable "tenant_domain" {
  description = "Azure AD tenant domain e.g. contoso.onmicrosoft.com"
  type        = string
  default     = "yourtenant.onmicrosoft.com"
}