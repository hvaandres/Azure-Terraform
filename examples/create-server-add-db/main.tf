provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_mssql_server" "example" {
  name                         = var.server_name
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = "1.2"
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

module "mssql_database" {
  source = "./path/to/your/module"  # Update this to the actual path
  
  name      = var.database_name
  server_id = azurerm_mssql_server.example.id
  
  collation                   = var.collation
  license_type                = var.license_type
  max_size_gb                 = var.max_size_gb
  sku_name                    = var.sku_name
  zone_redundant              = var.zone_redundant
  read_scale                  = var.read_scale
  storage_account_type        = var.storage_account_type
  transparent_data_encryption_enabled = var.transparent_data_encryption_enabled
  
  # Instead of using nested blocks directly, provide objects to the variables
  threat_detection_policy = var.enable_threat_detection_policy ? {
    state                = "Enabled"
    disabled_alerts      = ["Sql_Injection", "Data_Exfiltration"]
    email_account_admins = true
    email_addresses      = ["security@example.com"]
    retention_days       = 30
  } : null
  
  short_term_retention_policy = {
    retention_days = 7
  }
  
  long_term_retention_policy = {
    weekly_retention  = "P1W"
    monthly_retention = "P1M"
    yearly_retention  = "P1Y"
    week_of_year      = 1
  }
  
  geo_backup_policy = {
    state = "Enabled"
  }

  tags = var.tags
}