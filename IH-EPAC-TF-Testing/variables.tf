variable subscription_id {
  description = "The Azure subscription ID"
  type        = string
}

variable "resource_groups" {
  description = "Map of resource groups to create"
  type = map(object({
    base_name   = string
    location    = string
    tags        = optional(map(string))
  }))
}

variable "user_assigned_identities" {
  description = "Map of user assigned identities with their configurations"
  type = map(object({
    # Required fields
    name                = string
    resource_group_name = string
    location            = string

    # Optional fields
    tags = optional(map(string))
  }))
  default = {}
}

variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    account_kind             = optional(string, "StorageV2")
    tags                     = optional(map(string))
  }))
}

variable "storage_account_containers" {
  description = "Map of storage containers to create"
  type = map(object({
    storage_account_name = string
    container_name        = string
    public_access         = optional(string)
    metadata              = optional(map(string))
  }))
}

# variable "role_assignments" {
#   description = "Map of role assignments with their configurations"
#   type = map(object({
#     principal_id         = string
#     name                = string
#     role_definition_id  = string
#     scope               = string
#     # Optional fields
#     condition                   = optional(string)
#     condition_version          = optional(string)
#     delegated_managed_identity_resource_id = optional(string)
#     description               = optional(string)
#     principal_type           = optional(string)
#     skip_service_principal_aad_check = optional(bool)
#   }))
# }

# variable "federated_credentials" {
#   description = "Map of federated credentials to create"
#   type = map(object({
#     name                = string
#     resource_group_name = string
#     issuer              = string
#     subject             = string
#     audience            = optional(list(string))
#     parent_id           = string  # This should be the ID of the user-assigned managed identity
#   }))
# }



# variable "container_registries" {
#   description = "Map of container registries to create"
#   type = map(object({
#     name                = string
#     resource_group_name = string
#     location            = string
#     sku                 = string
#     admin_enabled       = optional(bool, false)
#     tags                = optional(map(string))
#   }))
# }

# variable "kubernetes_clusters" {
#   description = "Map of Kubernetes clusters to create"
#   type = map(object({
#     name                = string
#     location            = string
#     resource_group_name = string
#     dns_prefix          = string
#     default_node_pool   = object({
#       name       = string
#       node_count = number
#       vm_size    = string
#     })
#     tags = optional(map(string))
#   }))
# }