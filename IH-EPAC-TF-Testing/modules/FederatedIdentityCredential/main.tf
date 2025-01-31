resource "azurerm_federated_identity_credential" "federated_identity" {
  for_each = var.federated_identity
  name = each.value.name
  resource_group_name = each.value.rg_name
  audience = [ each.value.audience_name ]
  issuer = each.value.issuer_url
  parent_id = each.value.user_assigned_identity_id
  subject = each.value.subject

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? each.value.timeouts : {}
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}