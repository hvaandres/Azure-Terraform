resource "azurerm_container_registry" "az-container-registry" {
  for_each = var.container_registries

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  sku                           = each.value.sku
  admin_enabled                 = each.value.admin_enabled
  public_network_access_enabled = each.value.public_network_access_enabled

  dynamic "network_rule_set" {
    for_each = each.value.sku == "Premium" && !each.value.public_network_access_enabled ? [1] : []
    content {
      default_action = "Deny"
      ip_rule {
        action   = "Allow"
        ip_range = each.value.allowed_ip_range
      }
    }
  }

  dynamic "retention_policy" {
    for_each = each.value.retention_policy != null ? [1] : []
    content {
      days    = each.value.retention_policy.days
      enabled = each.value.retention_policy.enabled
    }
  }

  tags = each.value.tags
}
