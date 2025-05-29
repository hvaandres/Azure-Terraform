variable "container_registries" {
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = string
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    allowed_ip_range              = optional(string)
    retention_policy = optional(object({
      days    = number
      enabled = bool
    }))
    tags = optional(map(string))
  }))
  description = "Map of Azure Container Registries to create"
}
