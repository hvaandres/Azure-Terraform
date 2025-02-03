resource "azurerm_storage_container" "container" {
  for_each = {
    for container in flatten([
      for sa_key, sa in var.storage_accounts : [
        for container_key, container in coalesce(sa.containers, {}) : {
          sa_key         = sa_key
          container_key  = container_key
          container     = container
          storage_account_name = sa.name
          storage_account_id   = azurerm_storage_account.storage[sa_key].id
        }
      ]
    ]) : "${container.sa_key}.${container.container_key}" => container
  }

  name                  = each.value.container.name
  storage_account_id    = each.value.storage_account_id
  container_access_type = each.value.container.container_access_type
  metadata             = try(each.value.container.metadata, null)
  depends_on           = [azurerm_storage_account.storage]
}