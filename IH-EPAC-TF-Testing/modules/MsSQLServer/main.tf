# Azure SQL Server Module (Corrected)
# Based on the latest azurerm provider documentation

variable "name" {
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

variable "version" {
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
    key_vault_key_id                     = string
    primary_user_assigned_identity_id    = optional(string)
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

variable "timeouts" {
  description = "The timeouts for the resource"
  type = object({
    create = optional(string)
    update = optional(string)
    read   = optional(string)
    delete = optional(string)
  })
  default = null
}

# Local variables for handling dynamic blocks
locals {
  # Convert objects into a format suitable for dynamic blocks
  azuread_administrator_config = var.azuread_administrator != null ? [var.azuread_administrator] : []
  identity_config              = var.identity != null ? [var.identity] : []
  customer_managed_key_config  = var.customer_managed_key != null ? [var.customer_managed_key] : []
  extended_auditing_policy_config = var.extended_auditing_policy != null ? [var.extended_auditing_policy] : []
  timeouts_config              = var.timeouts != null ? [var.timeouts] : []
}

resource "azurerm_mssql_server" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.version
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
    for_each = local.timeouts_config
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

output "id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.this.name
}

output "fully_qualified_domain_name" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "restorable_dropped_database_ids" {
  description = "A list of dropped database IDs that can be restored"
  value       = azurerm_mssql_server.this.restorable_dropped_database_ids
}

output "identity" {
  description = "The identity of the SQL Server if configured"
  value       = azurerm_mssql_server.this.identity
}