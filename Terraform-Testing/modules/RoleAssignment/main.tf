resource "azurerm_role_assignment" "role_assignment" {
  for_each = var.role_assignments
  
  # Required fields
  principal_id = each.value.principal_id
  role_definition_id = each.value.role_definition_id
  scope        = each.value.scope
  
  # Optional fields
  condition                   = each.value.condition
  condition_version          = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  description               = each.value.description
  principal_type           = each.value.principal_type
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
}
