
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
    Contact       = "Alan Haro"
    Department    = "CyberSecurity"
    Support = "support@support.com"

  }
}

variable "identity_rg_name" {
    type = string
    description = "The base name of the resource group"
}

variable "base_name" {
    type = string
    description = "The base name of the resource"
    default = "aharo-test01"
  
}