provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "secure_rg" {
  name     = "${var.prefix}-secure-rg"
  location = var.location
  tags     = var.tags
}

# Create key vault for encryption
resource "azurerm_key_vault" "secure_kv" {
  name                        = "${var.prefix}-secure-kv"
  location                    = azurerm_resource_group.secure_rg.location
  resource_group_name         = azurerm_resource_group.secure_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  sku_name                    = "standard"
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    
    key_permissions = [
      "Get", "Create", "List", "Delete", "Purge", "Recover", "GetRotationPolicy",
      "WrapKey", "UnwrapKey"
    ]
  }
  
  tags = var.tags
}

data "azurerm_client_config" "current" {}

# Create encryption key
resource "azurerm_key_vault_key" "sql_encryption_key" {
  name         = "sql-encryption-key"
  key_vault_id = azurerm_key_vault.secure_kv.id
  key_type     = "RSA"
  key_size     = 2048
  
  key_opts = [
    "decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"
  ]
  
  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    
    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}

# Create storage account for auditing
resource "azurerm_storage_account" "audit_storage" {
  name                     = "${var.prefix}auditstorage"
  resource_group_name      = azurerm_resource_group.secure_rg.name
  location                 = azurerm_resource_group.secure_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
  
  blob_properties {
    delete_retention_policy {
      days = 365
    }
    container_delete_retention_policy {
      days = 365
    }
  }
  
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = var.allowed_ip_ranges
  }
  
  tags = var.tags
}

# Create SQL Server with enhanced security
resource "azurerm_mssql_server" "secure_server" {
  name                          = "${var.prefix}-secure-sql"
  resource_group_name           = azurerm_resource_group.secure_rg.name
  location                      = azurerm_resource_group.secure_rg.location
  version                       = "12.0"
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false  # For maximum security
  
  identity {
    type = "SystemAssigned"
  }
  
  azuread_administrator {
    login_username = var.ad_admin_username
    object_id      = var.ad_admin_object_id
    tenant_id      = data.azurerm_client_config.current.tenant_id
  }
  
  tags = var.tags
}

# Configure server auditing
resource "azurerm_mssql_server_extended_auditing_policy" "server_audit" {
  server_id                               = azurerm_mssql_server.secure_server.id
  storage_endpoint                        = azurerm_storage_account.audit_storage.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.audit_storage.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
  log_monitoring_enabled                  = true
}

# Configure server vulnerability assessment
resource "azurerm_mssql_server_vulnerability_assessment" "secure_assessment" {
  server_id                    = azurerm_mssql_server.secure_server.id
  storage_container_path       = "${azurerm_storage_account.audit_storage.primary_blob_endpoint}vulnerability-assessment/"
  storage_account_access_key   = azurerm_storage_account.audit_storage.primary_access_key
  recurring_scans {
    enabled                    = true
    email_subscription_admins  = true
    emails                     = var.security_email_addresses
  }
}

# Create private endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_endpoint" {
  name                = "${var.prefix}-sql-endpoint"
  location            = azurerm_resource_group.secure_rg.location
  resource_group_name = azurerm_resource_group.secure_rg.name
  subnet_id           = var.subnet_id
  
  private_service_connection {
    name                           = "${var.prefix}-privateserviceconnection"
    private_connection_resource_id = azurerm_mssql_server.secure_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
  
  tags = var.tags
}

# Create highly secure database
module "secure_database" {
  source = "./path/to/your/module"
  
  name      = var.database_name
  server_id = azurerm_mssql_server.secure_server.id
  
  # Database configuration
  collation           = var.collation
  license_type        = "LicenseIncluded"
  max_size_gb         = var.max_size_gb
  sku_name            = var.sku_name  # Business Critical tier recommended for highest security
  zone_redundant      = true
  storage_account_type = "Zone"  # Zone-redundant backups
  
  # Security settings - enable TDE
  transparent_data_encryption_enabled = true
  
  # Enhanced security through threat detection
  threat_detection_policy = {
    state                      = "Enabled"
    disabled_alerts            = []  # Enable all alerts
    email_account_admins       = true
    email_addresses            = var.security_email_addresses
    retention_days             = 365
    storage_endpoint           = azurerm_storage_account.audit_storage.primary_blob_endpoint
    storage_account_access_key = azurerm_storage_account.audit_storage.primary_access_key
  }
  
  # Backup retention policies
  short_term_retention_policy = {
    retention_days = 35  # Maximum allowed for short-term retention
  }
  
  long_term_retention_policy = {
    weekly_retention  = "P8W"
    monthly_retention = "P12M"
    yearly_retention  = "P10Y"
    week_of_year      = 1
  }
  
  # Enable geo-backup as additional protection layer
  geo_backup_policy = {
    state = "Enabled"
  }
  
  tags = merge(var.tags, {
    classification = "confidential"
    compliance    = "hipaa-hitrust"
    encryption    = "customer-managed-key"
  })
  
  depends_on = [
    azurerm_mssql_server_extended_auditing_policy.server_audit,
    azurerm_private_endpoint.sql_endpoint
  ]
}

# Configure database auditing
resource "azurerm_mssql_database_extended_auditing_policy" "db_audit" {
  database_id                             = module.secure_database.database_id
  storage_endpoint                        = azurerm_storage_account.audit_storage.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.audit_storage.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
  log_monitoring_enabled                  = true
}

# Customer-managed key for TDE
resource "azurerm_mssql_server_transparent_data_encryption" "tde_encryption" {
  server_id          = azurerm_mssql_server.secure_server.id
  key_vault_key_id   = azurerm_key_vault_key.sql_encryption_key.id
  auto_rotation_enabled = true
}

# Variables
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "secure"
}

variable "subnet_id" {
  description = "The ID of the subnet to use for private endpoint"
  type        = string
}

variable "security_email_addresses" {
  description = "Email addresses for security notifications"
  type        = list(string)
  default     = ["security@example.com", "dba@example.com"]
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access the storage account"
  type        = list(string)
  default     = []
}

variable "ad_admin_username" {
  description = "Azure AD admin username"
  type        = string
}

variable "ad_admin_object_id" {
  description = "Azure AD admin object ID"
  type        = string
}

# Outputs
output "database_id" {
  description = "The ID of the secure database"
  value       = module.secure_database.database_id
}

output "server_fqdn" {
  description = "The fully qualified domain name of the SQL server"
  value       = azurerm_mssql_server.secure_server.fully_qualified_domain_name
}

output "private_endpoint_ip" {
  description = "Private IP address of the SQL server endpoint"
  value       = azurerm_private_endpoint.sql_endpoint.private_service_connection[0].private_ip_address
}

output "storage_account_id" {
  description = "The ID of the storage account used for auditing"
  value       = azurerm_storage_account.audit_storage.id
}