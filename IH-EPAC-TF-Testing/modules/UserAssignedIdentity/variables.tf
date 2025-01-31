variable "user_assigned_identity" {
  description = "The user-assigned identity for the module"
  type        = map(object({
    user_assigned_identity_name = string
    resource_group_name = string
    location = string
    tags = optional(map(string))
  }))
}