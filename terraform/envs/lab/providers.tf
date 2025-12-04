terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "95f5b230-2ac0-46e4-9e78-213a57b19bda"
  tenant_id       = "8b36a591-80dc-44e6-aefc-29e07f135ebd"
}
