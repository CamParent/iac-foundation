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