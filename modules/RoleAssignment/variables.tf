variable "principal_id" {
  description = "The principal ID to assign the role to."
  type        = string
}

variable "role_name" {
  description = "The name of the role to assign."
  type        = string
}

variable "scope_id" {
  description = "The scope at which the role assignment applies."
  type        = string
}