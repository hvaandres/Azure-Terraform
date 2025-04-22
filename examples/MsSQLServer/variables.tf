variable "server_name" {
  type        = string
  description = "The name of the SQL server."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the server will be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be deployed."
}

variable "administrator_login" {
  type        = string
  description = "The administrator login for the SQL server."
}

variable "administrator_login_password" {
  type        = string
  description = "The administrator login password for the SQL server."
  sensitive   = true # Mark as sensitive to prevent accidental exposure
}

variable "firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "A map of firewall rules to apply to the server."
}

variable "databases" {
  type = map(object({
    name     = string
    sku_name = string
  }))
  description = "A map of databases to create on the server."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources."
  default     = {}
}