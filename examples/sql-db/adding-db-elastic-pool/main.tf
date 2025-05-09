provider "azurerm" {
  features {}
}

# Reference the existing server and elastic pool
data "azurerm_mssql_server" "existing" {
  name                = var.existing_server_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_mssql_elasticpool" "existing" {
  name                = var.elastic_pool_name
  resource_group_name = var.existing_resource_group_name
  server_name         = var.existing_server_name
}

# Create multiple databases in the elastic pool using count
module "elastic_pool_databases" {
  source   = "./path/to/your/module"
  count    = length(var.database_names)
  
  name     = var.database_names[count.index]
  server_id = data.azurerm_mssql_server.existing.id
  
  # Connect to the elastic pool
  elastic_pool_id = data.azurerm_mssql_elasticpool.existing.id
  
  # Basic database settings
  collation    = var.collation
  license_type = var.license_type
  
  # When using elastic pool, these settings are managed at the pool level
  # so we don't need to specify them for individual databases
  max_size_gb  = null
  sku_name     = null
  
  # Backup and high availability settings
  zone_redundant = var.zone_redundant  # Should match elastic pool setting
  storage_account_type = var.storage_account_type
  
  short_term_retention_policy = {
    retention_days = var.backup_retention_days
  }
  
  # Security settings
  transparent_data_encryption_enabled = true
  
  threat_detection_policy = var.enable_threat_detection ? {
    state                = "Enabled"
    disabled_alerts      = var.threat_detection_disabled_alerts
    email_account_admins = var.email_admins_for_alerts
    email_addresses      = var.alert_email_addresses
    retention_days       = var.alert_retention_days
  } : null
  
  tags = merge(var.tags, {
    elastic_pool = var.elastic_pool_name
    application  = var.application_name
    environment  = var.environment
  })
}

# Variables for the elastic pool example
variable "elastic_pool_name" {
  description = "The name of the existing elastic pool."
  type        = string
}

variable "database_names" {
  description = "List of database names to create in the elastic pool."
  type        = list(string)
  # Example: ["customer-db", "product-db", "order-db"]
}
variable "application_name" {
  description = "Name of the application these databases belong to."
  type        = string
  default     = "microservices-app"
}

variable "existing_server_name" {
  description = "The name of the existing server."
  type        = string
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group."
  type        = string
}
}

# Output all database IDs
output "database_ids" {
  description = "The IDs of all databases created in the elastic pool."
  value       = module.elastic_pool_databases[*].database_id
}

# Output connection strings for all databases
output "connection_strings" {
  description = "Connection strings for all databases."
  value = [
    for i, db_name in var.database_names : 
    "Server=tcp:${data.azurerm_mssql_server.existing.fully_qualified_domain_name},1433;Initial Catalog=${db_name};Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ]
}

output "elastic_pool_details" {
  description = "Details of the elastic pool."
  value = {
    id        = data.azurerm_mssql_elasticpool.existing.id
    name      = data.azurerm_mssql_elasticpool.existing.name
    max_size_gb = data.azurerm_mssql_elasticpool.existing.max_size_gb
    per_database_settings = {
      min_capacity = data.azurerm_mssql_elasticpool.existing.per_database_settings[0].min_capacity
      max_capacity = data.azurerm_mssql_elasticpool.existing.per_database_settings[0].max_capacity
    }
  }
}