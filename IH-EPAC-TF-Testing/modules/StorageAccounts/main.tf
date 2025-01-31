resource "azurerm_storage_account" "az-storage-account" {
  name                     = "st${var.base_name}tf"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  public_network_access_enabled = var.public_network_access_enabled
  tags = var.tags
}

