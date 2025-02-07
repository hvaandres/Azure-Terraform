output "principal_ids" {
  value = module.user_assigned_identity.principal_ids
}

output "role_definition_id" {
  value = data.azurerm_role_definition.example.id
}

output "principal_ids_debug" {
  value = module.user_assigned_identity.principal_ids
}

# output "role_assignments_debug" {
#   value = local.role_assignments
# }