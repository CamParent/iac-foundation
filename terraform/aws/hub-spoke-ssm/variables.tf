variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "iac-foundation"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}

variable "hub_vpc_cidr" {
  description = "CIDR block for Hub VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke_vpc_cidr" {
  description = "CIDR block for Spoke VPC"
  type        = string
  default     = "10.1.0.0/16"
}
