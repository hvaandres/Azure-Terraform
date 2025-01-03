variable "location" {
  description = "The location where the user-assigned managed identity will be created."
  type = string
}

variable "name" {
  description = "The name of the user-assigned managed identity."
  type  = string
}

variable "rg_name" {
  description = "The name of the resource group in which the user-assigned managed identity will be created."
  type = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment     = "Testing"
    Project         = "Terraform"
    Contact       = "Andres Haro"
    Department    = "CyberSecurity"
    Support = "test@test.com"

  }
}