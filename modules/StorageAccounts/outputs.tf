output "storage_account_names" {
  description = "List of created storage account names"
  value       = { for k, v in azurerm_storage_account.storage : k => v.name }
}

output "storage_account_ids" {
  description = "List of created storage account IDs"
  value       = { for k, v in azurerm_storage_account.storage : k => v.id }
}

output "storage_account_primary_endpoints" {
  description = "Primary endpoints for each storage account"
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_blob_endpoint }
}

output "storage_account_keys" {
  description = "Primary access keys for each storage account"
  sensitive   = true
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_access_key }
}
