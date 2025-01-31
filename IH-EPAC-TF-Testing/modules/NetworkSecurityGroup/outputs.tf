output "network_security_group_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.az-network-security-group.id
}

output "network_security_group_name" {
  description = "The name of the Network Security Group"
  value       = azurerm_network_security_group.az-network-security-group.name
  
}

output "network_security_group_location" {
  description = "The location of the Network Security Group"
  value       = azurerm_network_security_group.az-network-security-group.location
  
}

output "network_security_group_resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_network_security_group.az-network-security-group.resource_group_name
  
}