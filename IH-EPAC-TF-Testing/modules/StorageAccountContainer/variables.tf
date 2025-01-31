variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type = map(object({
    name                              = string
    resource_group_name              = string
    location                         = string
    account_tier                     = string
    account_replication_type         = string
    account_kind                     = optional(string)
    enable_https_traffic_only        = optional(bool)
    min_tls_version                  = optional(string)
    allow_nested_items_to_be_public  = optional(bool)
    shared_access_key_enabled        = optional(bool)
    public_network_access_enabled    = optional(bool)
    default_to_oauth_authentication  = optional(bool)
    is_hns_enabled                   = optional(bool)
    nfsv3_enabled                    = optional(bool)
    cross_tenant_replication_enabled = optional(bool)
    tags                            = optional(map(string))
    containers = map(object({
      name                  = string
      container_access_type = optional(string)
      metadata             = optional(map(string))
    }))
  }))

  default = {
    "example_storage" = {
      name                             = "examplestorage"
      resource_group_name             = "example-resources"
      location                        = "East US"
      account_tier                    = "Standard"
      account_replication_type        = "LRS"
      account_kind                    = "StorageV2"
      enable_https_traffic_only       = true
      min_tls_version                 = "TLS1_2"
      allow_nested_items_to_be_public = false
      shared_access_key_enabled       = true
      public_network_access_enabled   = true
      default_to_oauth_authentication = false
      is_hns_enabled                  = false
      nfsv3_enabled                   = false
      tags = {
        environment = "Production"
        purpose     = "Example"
      }
      containers = {
        "public-container" = {
          name                  = "public-container"
          container_access_type = "blob"
          metadata = {
            purpose = "Public assets"
            department = "Marketing"
          }
        },
        "private-container" = {
          name                  = "private-container"
          container_access_type = "private"
          metadata = {
            purpose = "Private documents"
            department = "Finance"
          }
        },
        "logs-container" = {
          name                  = "logs-container"
          container_access_type = "private"
          metadata = {
            purpose = "Application logs"
            retention = "30days"
          }
        }
      }
    },
    "backup_storage" = {
      name                             = "backupstorage"
      resource_group_name             = "example-resources"
      location                        = "West US"
      account_tier                    = "Standard"
      account_replication_type        = "GRS"
      account_kind                    = "StorageV2"
      enable_https_traffic_only       = true
      allow_nested_items_to_be_public = false
      tags = {
        environment = "Production"
        purpose     = "Backup"
      }
      containers = {
        "backup-container" = {
          name                  = "backup-container"
          container_access_type = "private"
          metadata = {
            purpose = "System backups"
            retention = "90days"
          }
        }
      }
    }
  }
}