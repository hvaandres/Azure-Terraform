output "base_name" {
  description = "The base name of the resource group"
  value       = var.base_name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = var.resource_group_name
}

output "location" {
  description = "The location of the resource"
  value       = var.location
}

output "account_tier" {
  description = "The storage account tier"
  value       = var.account_tier
}

output "account_replication_type" {
  description = "The replication type of the storage account"
  value       = var.account_replication_type
}

output "tags" {
  description = "Common tags for all resources"
  value       = var.tags
}

// StorageAccounts module's output.tf
output "storage_account_id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.az-storage-account.id
}