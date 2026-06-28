variable "environment" {
  description = "Environment name"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

# --- Users ---
variable "users" {
  description = "Map of Azure AD users to create"
  type = map(object({
    display_name        = string
    user_principal_name = string
    mail_nickname       = string
  }))
  default = {}
}

# --- Groups ---
variable "groups" {
  description = "Map of Azure AD groups to create"
  type = map(object({
    display_name     = string
    description      = string
    assignable_to_role = bool
  }))
  default = {}
}

# --- Role Assignments ---
variable "role_assignments" {
  description = "List of Azure RBAC role assignments"
  type = list(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
  default = []
}

# --- App Registrations ---
variable "app_registrations" {
  description = "Map of app registrations to create"
  type = map(object({
    display_name     = string
    sign_in_audience = string
  }))
  default = {}
}

# --- Conditional Access ---
variable "conditional_access_policies" {
  description = "Map of Conditional Access policies"
  type = map(object({
    display_name      = string
    state             = string
    included_users    = list(string)
    excluded_users    = list(string)
    included_platforms = list(string)
    grant_controls    = list(string)
  }))
  default = {}
}