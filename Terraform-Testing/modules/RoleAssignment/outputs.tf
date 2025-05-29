output "role_assignments" {
  description = "Map of created role assignments"
  value = {
    for k, v in azurerm_role_assignment.role_assignment : k => {
      id  = v.id
      principal_id = v.principal_id
      role_definition_id = v.role_definition_id
      scope = v.scope
    }
  }
}