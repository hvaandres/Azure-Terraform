resource "azurerm_user_assigned_identity" "az-user-assigned-identity" {
  for_each = var.user_assigned_identity
  location = each.value.location
  name = each.value.user_assigned_identity_name
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
}