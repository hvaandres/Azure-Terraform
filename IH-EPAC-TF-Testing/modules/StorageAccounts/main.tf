resource "azurerm_storage_account" "storage" {
  for_each = var.storage_accounts

  # Required fields
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  # Optional fields with safe defaults
  account_kind = try(each.value.account_kind, "StorageV2")
  tags         = try(each.value.tags, {})

  # TLS minimum version
  min_tls_version = "TLS1_2"

  # public network access
  public_network_access_enabled = each.value.public_network_access_enabled

  # Blob properties with comprehensive configuration
  dynamic "blob_properties" {
    for_each = each.value.blob_properties != null ? [each.value.blob_properties] : []
    content {
      versioning_enabled = try(blob_properties.value.versioning_enabled, false)

      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_policy != null ? [blob_properties.value.container_delete_retention_policy] : []
        content {
          days = try(container_delete_retention_policy.value.days, 7)
        }
      }

      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = try(delete_retention_policy.value.days, 7)
        }
      }

      dynamic "cors_rule" {
        for_each = try(blob_properties.value.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  # Static website configuration
  dynamic "static_website" {
    for_each = each.value.static_website != null ? [each.value.static_website] : []
    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  # Network rules
  dynamic "network_rules" {
    for_each = each.value.network_rules != null ? [each.value.network_rules] : []
    content {
      default_action             = try(network_rules.value.default_action, "Deny")
      bypass                     = try(network_rules.value.bypass, ["AzureServices"])
      ip_rules                   = try(network_rules.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, [])
    }
  }
}