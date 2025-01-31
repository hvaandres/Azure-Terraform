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

variable "principal_id" {
#   description = "The principal ID to assign the role to."
#   type        = string
# }

# variable "role_name" {
#   description = "The name of the role to assign."
#   type        = string
# }

# variable "scope_id" {
#   description = "The scope at which the role assignment applies."
#   type        = string
# }