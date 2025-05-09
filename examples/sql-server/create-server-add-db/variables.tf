variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "example-mssql-rg"
}

variable "location" {
  description = "The Azure location where the resources should be created."
  type        = string
  default     = "East US"
}

variable "server_name" {
  description = "The name of the MS SQL Server."
  type        = string
  default     = "example-mssql-server"
}

variable "administrator_login" {
  description = "The administrator login name for the MS SQL Server."
  type        = string
  default     = "sqladmin"
}

variable "administrator_login_password" {
  description = "The administrator login password for the MS SQL Server."
  type        = string
  sensitive   = true
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the MS SQL Server."
  type        = bool
  default     = false
}

variable "database_name" {
  description = "The name of the MS SQL Database."
  type        = string
  default     = "example-db"
}

variable "collation" {
  description = "Specifies the collation of the database."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "Specifies the license type applied to this database."
  type        = string
  default     = "LicenseIncluded"
}

variable "max_size_gb" {
  description = "The max size of the database in gigabytes."
  type        = number
  default     = 32
}

variable "sku_name" {
  description = "Specifies the name of the SKU used by the database."
  type        = string
  default     = "S1"
}

variable "zone_redundant" {
  description = "Whether or not this database is zone redundant."
  type        = bool
  default     = false
}

variable "read_scale" {
  description = "If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica."
  type        = bool
  default     = false
}

variable "storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database."
  type        = string
  default     = "Geo"
}

variable "transparent_data_encryption_enabled" {
  description = "Whether or not this database is using transparent data encryption."
  type        = bool
  default     = true
}

variable "enable_threat_detection_policy" {
  description = "Enable threat detection policy."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {
    environment = "example"
    managed_by  = "terraform"
  }
}