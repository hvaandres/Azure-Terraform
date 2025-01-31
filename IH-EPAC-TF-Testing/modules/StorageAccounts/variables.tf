variable "storage_accounts" {
  type = map(object({
    name                     = string
    resource_group_name      = optional(string)
    location                 = optional(string)
    account_tier             = string
    account_replication_type = string
    account_kind             = optional(string, "StorageV2")
    tags                     = optional(map(string))
    enable_versioning        = optional(bool, false)
    enable_static_website    = optional(bool, false)
    index_document           = optional(string)
    error_document           = optional(string)
  }))
  description = "Map of storage accounts to create"
}

