variable "storage_accounts" {
  description = "A map of storage accounts to create"
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string

    # Optional fields
    account_kind = optional(string, "StorageV2")
    tags         = optional(map(string), {})

    # Blob properties
    blob_properties = optional(object({
      versioning_enabled = optional(bool, false)

      container_delete_retention_policy = optional(object({
        days = optional(number, 7)
      }))

      delete_retention_policy = optional(object({
        days = optional(number, 7)
      }))

      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), [])
    }))

    # Static website configuration
    static_website = optional(object({
      index_document     = string
      error_404_document = string
    }))

    # Network rules
    network_rules = optional(object({
      default_action             = optional(string, "Deny")
      bypass                     = optional(list(string), ["AzureServices"])
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }))
  }))
}
