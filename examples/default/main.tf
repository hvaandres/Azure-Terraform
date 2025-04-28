provider "azurerm" {
  features {}
}

# Reference the existing server
data "azurerm_mssql_server" "existing" {
  name                = var.existing_server_name
  resource_group_name = var.existing_resource_group_name
}

module "mssql_database" {
  source = "./path/to/your/module"  # Update this to the actual path
  
  name      = var.database_name
  server_id = data.azurerm_mssql_server.existing.id
  
  # Database configuration
  collation                   = var.collation
  license_type                = var.license_type
  max_size_gb                 = var.max_size_gb
  sku_name                    = var.sku_name
  zone_redundant              = var.zone_redundant
  read_scale                  = var.read_scale
  storage_account_type        = var.storage_account_type
  transparent_data_encryption_enabled = var.transparent_data_encryption_enabled
  
  # Backup and retention policies
  short_term_retention_policy = {
    retention_days = var.backup_retention_days
  }
  
  long_term_retention_policy = var.enable_long_term_retention ? {
    weekly_retention  = var.weekly_retention
    monthly_retention = var.monthly_retention
    yearly_retention  = var.yearly_retention
    week_of_year      = var.week_of_year
  } : null
  
  geo_backup_policy = {
    state = var.geo_backup_enabled ? "Enabled" : "Disabled"
  }
  
  # Threat detection
  threat_detection_policy = var.enable_threat_detection ? {
    state                = "Enabled"
    disabled_alerts      = var.threat_detection_disabled_alerts
    email_account_admins = var.email_admins_for_alerts
    email_addresses      = var.alert_email_addresses
    retention_days       = var.alert_retention_days
  } : null

  tags = var.tags
}