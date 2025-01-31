resource "azurerm_storage_container" "az-storage-account-container" {
  name                  = var.base_name_container
  storage_account_id    = var.storage_account_id
  container_access_type = var.container_access_type
}