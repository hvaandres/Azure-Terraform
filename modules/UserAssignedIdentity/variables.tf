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