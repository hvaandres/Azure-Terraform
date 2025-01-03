resource "azurerm_resource_group" "identity_rg_name" {
    name = "RG-${var.base_name}-identity"
    location = var.location
    tags = var.tags
}