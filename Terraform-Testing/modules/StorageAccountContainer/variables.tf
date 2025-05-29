variable "storage_accounts" {
  type = map(object({
    name     = string
    # other storage account attributes
    containers = optional(map(object({
      name                  = string
      container_access_type = optional(string, "private")
      metadata             = optional(map(string))
    })), {})
  }))
}