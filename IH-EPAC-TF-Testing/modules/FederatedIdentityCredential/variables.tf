variable "federated_credentials" {
  description = "Map of federated credentials to create"
  type = map(object({
    name                = string
    resource_group_name = string
    issuer              = string
    subject             = string
    audience            = optional(list(string))
    parent_id           = string
  }))
}