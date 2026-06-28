output "user_object_ids" {
  description = "Object IDs of created Azure AD users"
  value       = { for k, v in azuread_user.this : k => v.object_id }
}

output "group_object_ids" {
  description = "Object IDs of created Azure AD groups"
  value       = { for k, v in azuread_group.this : k => v.object_id }
}

output "app_registration_client_ids" {
  description = "Client IDs of created app registrations"
  value       = { for k, v in azuread_application.this : k => v.client_id }
}

output "service_principal_object_ids" {
  description = "Object IDs of created service principals"
  value       = { for k, v in azuread_service_principal.this : k => v.object_id }
}

output "conditional_access_policy_ids" {
  description = "IDs of created Conditional Access policies"
  value       = { for k, v in azuread_conditional_access_policy.this : k => v.id }
}