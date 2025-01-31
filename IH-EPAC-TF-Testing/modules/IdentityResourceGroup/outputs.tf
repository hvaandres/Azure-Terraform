output "identity_rg_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.identity_rg_name.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.identity_rg_name.location
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.identity_rg_name.id
}

output "resource_group_tags" {
  description = "The tags applied to the resource group"
  value       = azurerm_resource_group.identity_rg_name.tags
}