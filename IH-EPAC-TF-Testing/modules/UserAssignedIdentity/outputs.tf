output "principal_ids" {
  value = { for k, v in azurerm_user_assigned_identity.user_identity : k => v.principal_id }
}