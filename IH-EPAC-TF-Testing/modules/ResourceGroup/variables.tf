variable "resource_groups" {
  description = "Map of resource groups to create"
  type        = map(object({
    base_name = string
    location  = string
    tags      = optional(map(string))
  }))
}