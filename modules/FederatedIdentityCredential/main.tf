resource "azurerm_federated_identity_credential" "this" {
  for_each            = var.federated_credentials
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  audience            = each.value.audience != null ? each.value.audience : ["api://AzureADTokenExchange"]
  issuer              = each.value.issuer
  parent_id           = each.value.parent_id
  subject             = each.value.subject
}