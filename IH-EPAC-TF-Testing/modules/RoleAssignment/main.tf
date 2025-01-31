resource "azurerm_role_assignment" "role" {
  principal_id = var.principal_id
  role_definition_name = var.role_name
  scope = var.scope_id
}

resource "azurerm_role_assignment" "role-assignment" {
  for_each = var.role_assignments
  principal_id = each.value.principal_id
  name = each.value.name
  role_definition_id = each.value.role_definition_id
  scope = each.value.scope
}