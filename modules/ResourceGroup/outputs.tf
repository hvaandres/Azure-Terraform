output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.test-resource-group.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.test-resource-group.location
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.test-resource-group.id
}

output "resource_group_tags" {
  description = "The tags applied to the resource group"
  value       = azurerm_resource_group.test-resource-group.tags
}