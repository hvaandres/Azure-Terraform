output "storage_container_names" {
  description = "Names of the created storage containers"
  value       = { for k, v in azurerm_storage_container.container : k => v.name }
}

output "storage_container_ids" {
  description = "IDs of the created storage containers"
  value       = { for k, v in azurerm_storage_container.container : k => v.id }
}

output "storage_container_access_types" {
  description = "Access types of the created storage containers"
  value       = { for k, v in azurerm_storage_container.container : k => v.container_access_type }
}

output "storage_container_metadata" {
  description = "Metadata associated with each storage container"
  value       = { for k, v in azurerm_storage_container.container : k => v.metadata }
}
