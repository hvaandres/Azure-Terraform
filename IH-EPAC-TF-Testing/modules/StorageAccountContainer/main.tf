resource "azurerm_storage_container" "example" {
  for_each = {
    for container in flatten([
      for sa_key, sa in var.storage_accounts : [
        for container_key, container in sa.containers : {
          sa_key         = sa_key
          container_key  = container_key
          container     = container
        }
      ]
    ]) : "${container.sa_key}.${container.container_key}" => merge(container.container, {
      storage_account_name = var.storage_accounts[container.sa_key].name
    })
  }

  name                  = each.value.name
  storage_account_id    = each.value.storage_account_id
  container_access_type = each.value.container_access_type
  metadata             = each.value.metadata
  depends_on           = [azurerm_storage_account.storage_account]
}
