variable "location" {
  type    = string
  default = "eastus2"
}

variable "hub_rg_name" {
  type    = string
  default = "rg-hub-networking-tf"
}

variable "hub_vnet_name" {
  type    = string
  default = "vnet-hub-01-tf"
}

variable "hub_address_space" {
  type    = list(string)
  default = ["10.11.0.0/16"]
}

# NEW: spoke vars
variable "spoke_rg_name" {
  type    = string
  default = "rg-spoke-apps-tf"
}

variable "spoke_vnet_name" {
  type    = string
  default = "vnet-spoke-01-tf"
}

variable "spoke_address_space" {
  type    = list(string)
  default = ["10.21.0.0/16"]
}
