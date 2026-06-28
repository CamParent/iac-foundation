terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstatecam"
    container_name       = "tfstate"
    key                  = "lab.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "networking" {
  source = "../../modules/networking"

  location              = var.location
  environment           = var.environment
  prefix                = var.prefix
  hub_address_space     = ["10.0.0.0/16"]
  spoke_address_space   = ["10.1.0.0/16"]
  gateway_subnet_prefix = "10.0.0.0/27"
  appgw_subnet_prefix   = "10.0.1.0/24"
  spoke_subnet_prefix   = "10.1.0.0/24"
}

module "appgateway" {
  source = "../../modules/appgateway"

  location            = var.location
  environment         = var.environment
  prefix              = var.prefix
  resource_group_name = module.networking.hub_resource_group_name
  appgw_subnet_id     = module.networking.appgw_subnet_id
  waf_mode            = "Detection"
  backend_fqdns       = ["10.1.0.10"]
  sku_capacity        = 1

  depends_on = [module.networking]
}

module "private_endpoint" {
  source = "../../modules/private-endpoint"

  location                       = var.location
  environment                    = var.environment
  prefix                         = var.prefix
  resource_group_name            = module.networking.spoke_resource_group_name
  subnet_id                      = module.networking.spoke_workload_subnet_id
  private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.Sql/servers/sql-example"
  subresource_names              = ["sqlServer"]
  service_name                   = "sql"

  depends_on = [module.networking]
}

module "identity" {
  source = "../../modules/identity"

  environment = var.environment
  prefix      = var.prefix

  users = {
    "cam" = {
      display_name        = "Cam Parent"
      user_principal_name = "cam.parent@${var.tenant_domain}"
      mail_nickname       = "cam.parent"
    }
    "svc_terraform" = {
      display_name        = "Service Account - Terraform"
      user_principal_name = "svc.terraform@${var.tenant_domain}"
      mail_nickname       = "svc.terraform"
    }
  }

  groups = {
    "engineers" = {
      display_name       = "grp-cloud-engineers-${var.environment}"
      description        = "Cloud engineering team"
      assignable_to_role = true
    }
    "readers" = {
      display_name       = "grp-cloud-readers-${var.environment}"
      description        = "Read-only access group"
      assignable_to_role = false
    }
  }

  app_registrations = {
    "github_oidc" = {
      display_name     = "app-github-oidc-${var.environment}"
      sign_in_audience = "AzureADMyOrg"
    }
    "monitoring" = {
      display_name     = "app-monitoring-${var.environment}"
      sign_in_audience = "AzureADMyOrg"
    }
  }

  conditional_access_policies = {
    "require_mfa" = {
      display_name       = "cap-require-mfa-${var.environment}"
      state              = "enabledForReportingButNotEnforced"
      included_users     = ["All"]
      excluded_users     = []
      included_platforms = ["all"]
      grant_controls     = ["mfa"]
    }
  }

  role_assignments = []
}