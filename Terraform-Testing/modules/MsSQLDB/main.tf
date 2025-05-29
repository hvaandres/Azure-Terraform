resource "azurerm_mssql_database" "this" {
  name                        = var.name
  server_id                   = var.server_id
  collation                   = var.collation
  license_type                = var.license_type
  max_size_gb                 = var.max_size_gb
  read_scale                  = var.read_scale
  sku_name                    = var.sku_name
  zone_redundant              = var.zone_redundant
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  create_mode                 = var.create_mode
  creation_source_database_id = var.creation_source_database_id
  recover_database_id         = var.recover_database_id
  restore_point_in_time       = var.restore_point_in_time
  storage_account_type        = var.storage_account_type
  transparent_data_encryption_enabled = var.transparent_data_encryption_enabled

  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy != null ? [var.threat_detection_policy] : []
    content {
      state                      = threat_detection_policy.value.state
      disabled_alerts            = lookup(threat_detection_policy.value, "disabled_alerts", null)
      email_account_admins       = lookup(threat_detection_policy.value, "email_account_admins", null)
      email_addresses            = lookup(threat_detection_policy.value, "email_addresses", null)
      retention_days             = lookup(threat_detection_policy.value, "retention_days", null)
      storage_account_access_key = lookup(threat_detection_policy.value, "storage_account_access_key", null)
      storage_endpoint           = lookup(threat_detection_policy.value, "storage_endpoint", null)
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_policy != null ? [var.short_term_retention_policy] : []
    content {
      retention_days = short_term_retention_policy.value.retention_days
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention_policy != null ? [var.long_term_retention_policy] : []
    content {
      weekly_retention  = lookup(long_term_retention_policy.value, "weekly_retention", null)
      monthly_retention = lookup(long_term_retention_policy.value, "monthly_retention", null)
      yearly_retention  = lookup(long_term_retention_policy.value, "yearly_retention", null)
      week_of_year      = lookup(long_term_retention_policy.value, "week_of_year", null)
    }
  }

  dynamic "geo_backup_policy" {
    for_each = var.geo_backup_policy != null ? [var.geo_backup_policy] : []
    content {
      state = geo_backup_policy.value.state
    }
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.create_mode == "Default" || (var.create_mode != "Default" && (var.creation_source_database_id != null || var.recover_database_id != null || var.restore_point_in_time != null))
      error_message = "When create_mode is not Default, one of creation_source_database_id, recover_database_id, or restore_point_in_time must be specified."
    }
  }
}