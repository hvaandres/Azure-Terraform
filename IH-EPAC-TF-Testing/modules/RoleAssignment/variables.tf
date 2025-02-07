variable "role_assignments" {
  description = "Map of role assignments with their configurations"
  type = map(object({
    principal_id         = string
    name                = string
    role_definition_id  = string
    scope               = string
    # Optional fields
    condition                   = optional(string)
    condition_version          = optional(string)
    delegated_managed_identity_resource_id = optional(string)
    description               = optional(string)
    principal_type           = optional(string)
    skip_service_principal_aad_check = optional(bool)
  }))
}