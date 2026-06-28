terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

data "azuread_client_config" "current" {}

# --- Users ---
resource "azuread_user" "this" {
  for_each = var.users

  display_name        = each.value.display_name
  user_principal_name = each.value.user_principal_name
  mail_nickname       = each.value.mail_nickname
  password            = "ChangeMe123!"
  force_password_change = true

  lifecycle {
    ignore_changes = [password]
  }
}

# --- Groups ---
resource "azuread_group" "this" {
  for_each = var.groups

  display_name            = each.value.display_name
  description             = each.value.description
  security_enabled        = true
  mail_enabled            = false
  assignable_to_role      = each.value.assignable_to_role
}

# --- Group Members (add all users to their respective groups) ---
resource "azuread_group_member" "this" {
  for_each = var.users

  group_object_id  = azuread_group.this["engineers"].id
  member_object_id = azuread_user.this[each.key].id
}

# --- Role Assignments ---
resource "azurerm_role_assignment" "this" {
  for_each = { for idx, ra in var.role_assignments : idx => ra }

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

# --- App Registrations ---
resource "azuread_application" "this" {
  for_each = var.app_registrations

  display_name     = each.value.display_name
  sign_in_audience = each.value.sign_in_audience

  tags = ["environment:${var.environment}", "managed_by:terraform"]
}

# --- Service Principals (one per app registration) ---
resource "azuread_service_principal" "this" {
  for_each = var.app_registrations

  client_id = azuread_application.this[each.key].client_id

  app_role_assignment_required = false

  tags = ["environment:${var.environment}", "managed_by:terraform"]
}

# --- Conditional Access Policies ---
resource "azuread_conditional_access_policy" "this" {
  for_each = var.conditional_access_policies

  display_name = each.value.display_name
  state        = each.value.state

  conditions {
    users {
      included_users = each.value.included_users
      excluded_users = each.value.excluded_users
    }

      applications {
      included_applications = ["All"]
    }

    platforms {
      included_platforms = each.value.included_platforms
    }

    client_app_types = ["all"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = each.value.grant_controls
  }
}