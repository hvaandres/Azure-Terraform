resource "azurerm_storage_account" "az-storage-account" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  account_kind             = each.value.account_kind

  tags = each.value.tags != null ? each.value.tags : {}

  dynamic "blob_properties" {
    for_each = each.value.enable_versioning ? [1] : []
    content {
      versioning_enabled = true
    }
  }

  dynamic "static_website" {
    for_each = each.value.enable_static_website ? [1] : []
    content {
      index_document     = each.value.index_document
      error_404_document = each.value.error_document
    }
  }
}