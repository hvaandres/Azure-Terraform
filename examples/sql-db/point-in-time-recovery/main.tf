provider "azurerm" {
  features {}
}

# Reference the existing server and source database
data "azurerm_mssql_server" "existing" {
  name                = var.existing_server_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_mssql_database" "source" {
  name      = var.source_database_name
  server_id = data.azurerm_mssql_server.existing.id
}

# Create restored database using point-in-time restore
module "restored_database" {
  source = "./path/to/your/module"
  
  name      = "${var.source_database_name}-restored"
  server_id = data.azurerm_mssql_server.existing.id
  
  # Specify the restore configuration
  create_mode              = "PointInTimeRestore"
  creation_source_database_id = data.azurerm_mssql_database.source.id
  restore_point_in_time    = var.restore_point_in_time
  
  # Maintain or modify other database settings as needed
  sku_name                 = var.sku_name
  max_size_gb              = var.max_size_gb
  zone_redundant           = var.zone_redundant
  storage_account_type     = var.storage_account_type
  
  # Configure backup policies
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
  
  # Security settings
  transparent_data_encryption_enabled = true
  
  tags = merge(var.tags, {
    original_database = var.source_database_name
    restore_time      = replace(var.restore_point_in_time, ":", "-")
    restore_purpose   = var.restore_purpose
  })
}

# Variables for the point-in-time restore example
variable "source_database_name" {
  description = "The name of the source database to restore from."
  type        = string
}

variable "restore_point_in_time" {
  description = "The point in time to restore the database to (RFC3339 format)."
  type        = string
  # Example: "2025-04-15T08:00:00Z"
}

variable "restore_purpose" {
  description = "The purpose of this database restore."
  type        = string
  default     = "recovery"
}