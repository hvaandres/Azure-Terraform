resource "azurerm_user_assigned_identity" "user_identity" {
  for_each            = var.user_assigned_identities
  # Required fields
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  # Optional fields
  tags = each.value.tags != null ? each.value.tags : {}
}