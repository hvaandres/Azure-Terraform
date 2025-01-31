variable "base_name" {
  type        = string
  description = "The base name of the resource group"
}

variable "resource_group_name" {
  type        = string
  description = "The base name for the resource group"
}

variable "location" {
  type        = string
  description = "The base location of the resource"
}

variable "account_tier" {
  type        = string
  description = "Account tier that the storage account will use"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Account replication type"
  default     = "GRS"
}

variable "public_network_access_enabled" {
  type = string
  description = "We need to disabled public access due to azure policies"
  default = "false"
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