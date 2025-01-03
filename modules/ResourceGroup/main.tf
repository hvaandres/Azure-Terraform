resource "azurerm_resource_group" "test-resource-group" {
    name = "RG-${var.base_name}-TF"
    location = var.location
    tags = var.tags
}