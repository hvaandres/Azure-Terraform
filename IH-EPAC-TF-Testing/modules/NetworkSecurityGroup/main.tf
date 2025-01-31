resource "azurerm_network_security_group" "az-network-security-group" {
    name = var.base_name_network_security_group
    location = var.location
    resource_group_name = var.resource_group_name  
}