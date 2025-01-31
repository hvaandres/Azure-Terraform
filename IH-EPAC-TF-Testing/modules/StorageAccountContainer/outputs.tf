output "storage_container_name" {
  value = azurerm_storage_container.az-storage-account-container.name
}

output "storage_container_access_type" {
  value = azurerm_storage_container.az-storage-account-container.container_access_type
}

output "storage_account_container_id" {
  description = "The ID of the storage account container."
  value       = azurerm_storage_container.az-storage-account-container.id
}


