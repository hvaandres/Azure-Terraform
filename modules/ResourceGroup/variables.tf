variable "base_name" {
    type = string
    description = "The base name of the resource group"
}

variable "location" {
    type = string
    description = "The base location of the resource"
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