output "role-assignment_id" {
  description = "The ID of the role assignment"
  value       = azurerm_role_assignment.role.id
}

output "role-assignment_principal_id" {
  description = "The principal ID of the role assignment"
  value       = azurerm_role_assignment.role.principal_id
}

output "role-assignment_role_definition_name" {
  description = "The role definition name of the role assignment"
  value       = azurerm_role_assignment.role.role_definition_name
}



output "role-assignment_scope" {
  description = "The scope of the role assignment"
  value       = azurerm_role_assignment.role.scope
}