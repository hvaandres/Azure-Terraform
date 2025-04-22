# Azure SQL Server and Database Module
# This module creates an Azure SQL Server and optional databases with dynamic optional parameters

###################################
# SQL Server Variables
###################################
variable "server_name" {
  description = "The name of the Microsoft SQL Server"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Microsoft SQL Server"
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists"
  type        = string
}

variable "server_version" {
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "The administrator login name for the server"
  type        = string
  default     = null
}

variable "administrator_login_password" {
  description = "The administrator login password"
  type        = string
  default     = null
  sensitive   = true
}

variable "connection_policy" {
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect"
  type        = string
  default     = null
}

variable "minimum_tls_version" {
  description = "The minimum TLS version to support on the server. Valid values are: 1.0, 1.1 and 1.2"
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be one of 1.0, 1.1, or 1.2."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for this server"
  type        = bool
  default     = true
}

variable "outbound_network_restriction_enabled" {
  description = "Whether outbound network traffic is restricted for this server"
  type        = bool
  default     = false
}

variable "primary_user_assigned_identity_id" {
  description = "The ID of the primary user assigned identity for the SQL Server"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "azuread_administrator" {
  description = "Azure AD administrator configuration for the SQL Server"
  type = object({
    login_username              = string
    object_id                   = string
    tenant_id                   = optional(string)
    azuread_authentication_only = optional(bool)
  })
  default = null
}

variable "identity" {
  description = "The identity type of the Microsoft SQL Server"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "customer_managed_key" {
  description = "Customer managed key configuration"
  type = object({
    key_vault_key_id                  = string
    primary_user_assigned_identity_id = optional(string)
  })
  default = null
}

variable "extended_auditing_policy" {
  description = "The extended audit policy for the SQL Server"
  type = object({
    storage_endpoint                        = optional(string)
    storage_account_access_key              = optional(string, null)
    storage_account_access_key_is_secondary = optional(bool, false)
    retention_in_days                       = optional(number, 0)
    log_monitoring_enabled                  = optional(bool, false)
  })
  default = null
}

variable "firewall_rules" {
  description = "Map of firewall rules to create"
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "server_timeouts" {
  description = "The timeouts for the server resource"
  type = object({
    create = optional(string)
    update = optional(string)
    read   = optional(string)
    delete = optional(string)
  })
  default = null
}

###################################
# SQL Database Variables
###################################
variable "databases" {
  description = "Map of databases to create on the SQL Server"
  type = map(object({
    # Required parameters
    name                         = string
    
    # Optional parameters with defaults
    collation                    = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    license_type                 = optional(string, null)
    max_size_gb                  = optional(number, null)
    read_scale                   = optional(bool, false)
    sku_name                     = optional(string, "Basic")
    zone_redundant               = optional(bool, false)
    
    # Geo-replication
    create_mode                  = optional(string, "Default")
    creation_source_database_id  = optional(string, null)
    restore_point_in_time        = optional(string, null)
    recover_database_id          = optional(string, null)
    restore_dropped_database_id  = optional(string, null)
    
    # Auto-pause and auto-resume
    auto_pause_delay_in_minutes  = optional(number, null)
    min_capacity                 = optional(number, null)
    
    # Advanced options
    ledger_enabled               = optional(bool, false)
    
    # Maintenance options
    maintenance_configuration_name = optional(string, null)
    
    # Transparent Data Encryption settings
    transparent_data_encryption_enabled = optional(bool, true)
    
    # Short Term Retention Policy
    short_term_retention_policy = optional(object({
      retention_days           = optional(number, 7)
      backup_interval_in_hours = optional(number, 24)
    }), null)
    
    # Long Term Retention Policy
    long_term_retention_policy = optional(object({
      weekly_retention  = optional(string, null)
      monthly_retention = optional(string, null)
      yearly_retention  = optional(string, null)
      week_of_year      = optional(number, null)
    }), null)
    
    # Timeouts
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      read   = optional(string)
      delete = optional(string)
    }), null)
    
    # Tags
    tags = optional(map(string), {})
  }))
  default = {}
}

# Local variables for handling dynamic blocks
locals {
  # Convert objects into a format suitable for dynamic blocks
  azuread_administrator_config = var.azuread_administrator != null ? [var.azuread_administrator] : []
  identity_config              = var.identity != null ? [var.identity] : []
  customer_managed_key_config  = var.customer_managed_key != null ? [var.customer_managed_key] : []
  extended_auditing_policy_config = var.extended_auditing_policy != null ? [var.extended_auditing_policy] : []
  server_timeouts_config       = var.server_timeouts != null ? [var.server_timeouts] : []
  
  # Database-related locals
  database_short_term_retention_policies = {
    for db_key, db in var.databases : 
      db_key => db.short_term_retention_policy if db.short_term_retention_policy != null
  }
  
  database_long_term_retention_policies = {
    for db_key, db in var.databases : 
      db_key => db.long_term_retention_policy if db.long_term_retention_policy != null
  }
}

###################################
# Resources
###################################

# SQL Server resource
resource "azurerm_mssql_server" "this" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  connection_policy            = var.connection_policy
  minimum_tls_version          = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled
  primary_user_assigned_identity_id = var.primary_user_assigned_identity_id
  tags                         = var.tags

  # Dynamic block for Azure AD administrator
  dynamic "azuread_administrator" {
    for_each = local.azuread_administrator_config
    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }

  # Dynamic block for identity
  dynamic "identity" {
    for_each = local.identity_config
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Dynamic block for customer managed key
  dynamic "customer_managed_key" {
    for_each = local.customer_managed_key_config
    content {
      key_vault_key_id                  = customer_managed_key.value.key_vault_key_id
      primary_user_assigned_identity_id = customer_managed_key.value.primary_user_assigned_identity_id
    }
  }

  # Dynamic block for extended auditing policy
  dynamic "extended_auditing_policy" {
    for_each = local.extended_auditing_policy_config
    content {
      storage_endpoint                        = extended_auditing_policy.value.storage_endpoint
      storage_account_access_key              = extended_auditing_policy.value.storage_account_access_key
      storage_account_access_key_is_secondary = extended_auditing_policy.value.storage_account_access_key_is_secondary
      retention_in_days                       = extended_auditing_policy.value.retention_in_days
      log_monitoring_enabled                  = extended_auditing_policy.value.log_monitoring_enabled
    }
  }

  # Dynamic block for timeouts
  dynamic "timeouts" {
    for_each = local.server_timeouts_config
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

# Create SQL Server firewall rules if specified
resource "azurerm_mssql_firewall_rule" "rules" {
  for_each = var.firewall_rules

  name             = each.key
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

# Create SQL Server databases
resource "azurerm_mssql_database" "databases" {
  for_each = var.databases

  name                        = each.value.name
  server_id                   = azurerm_mssql_server.this.id
  collation                   = each.value.collation
  license_type                = each.value.license_type
  max_size_gb                 = each.value.max_size_gb
  read_scale                  = each.value.read_scale
  sku_name                    = each.value.sku_name
  zone_redundant              = each.value.zone_redundant
  create_mode                 = each.value.create_mode
  creation_source_database_id = each.value.creation_source_database_id
  restore_point_in_time       = each.value.restore_point_in_time
  recover_database_id         = each.value.recover_database_id
  restore_dropped_database_id = each.value.restore_dropped_database_id
  auto_pause_delay_in_minutes = each.value.auto_pause_delay_in_minutes
  min_capacity                = each.value.min_capacity
  ledger_enabled              = each.value.ledger_enabled
  maintenance_configuration_name = each.value.maintenance_configuration_name
  transparent_data_encryption_enabled = each.value.transparent_data_encryption_enabled
  tags                        = merge(var.tags, each.value.tags)

  # Dynamic block for timeouts
  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

# Create Short Term Retention Policies
resource "azurerm_mssql_database_extended_auditing_policy" "short_term_policies" {
  for_each = local.database_short_term_retention_policies

  database_id            = azurerm_mssql_database.databases[each.key].id
  retention_in_days      = each.value.retention_days
  log_monitoring_enabled = true
}

# Create Long Term Retention Policies
resource "azurerm_mssql_database_long_term_retention_policy" "long_term_policies" {
  for_each = local.database_long_term_retention_policies

  database_id      = azurerm_mssql_database.databases[each.key].id
  weekly_retention  = each.value.weekly_retention
  monthly_retention = each.value.monthly_retention
  yearly_retention  = each.value.yearly_retention
  week_of_year      = each.value.week_of_year
}

###################################
# Outputs
###################################

output "server_id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.this.name
}

output "server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "server_identity" {
  description = "The identity of the SQL Server if configured"
  value       = azurerm_mssql_server.this.identity
}

output "databases" {
  description = "A map of database names and their IDs"
  value = {
    for db_key, db in azurerm_mssql_database.databases : 
      db_key => {
        id                     = db.id
        name                   = db.name
        creation_date          = db.creation_date
        default_secondary_location = db.default_secondary_location
      }
  }
}

output "firewall_rules" {
  description = "A map of firewall rule names and their IDs"
  value = {
    for rule_key, rule in azurerm_mssql_firewall_rule.rules : 
      rule_key => {
        id               = rule.id
        name             = rule.name
        start_ip_address = rule.start_ip_address
        end_ip_address   = rule.end_ip_address
      }
  }
}