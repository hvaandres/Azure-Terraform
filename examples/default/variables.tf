variable "existing_server_name" {
  description = "The name of the existing MS SQL Server."
  type        = string
}

variable "existing_resource_group_name" {
  description = "The name of the resource group containing the existing SQL server."
  type        = string
}

variable "database_name" {
  description = "The name of the MS SQL Database to create."
  type        = string
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

variable "backup_retention_days" {
  description = "The number of days to retain short term backups."
  type        = number
  default     = 7
}

variable "enable_long_term_retention" {
  description = "Whether to enable long-term retention policies."
  type        = bool
  default     = false
}

variable "weekly_retention" {
  description = "The weekly retention policy for an LTR backup (ISO 8601 format)."
  type        = string
  default     = "P1W"
}

variable "monthly_retention" {
  description = "The monthly retention policy for an LTR backup (ISO 8601 format)."
  type        = string
  default     = "P1M"
}

variable "yearly_retention" {
  description = "The yearly retention policy for an LTR backup (ISO 8601 format)."
  type        = string
  default     = "P1Y"
}

variable "week_of_year" {
  description = "The week of year to take the yearly backup."
  type        = number
  default     = 1
}

variable "geo_backup_enabled" {
  description = "Whether geo-backups should be enabled."
  type        = bool
  default     = true
}

variable "enable_threat_detection" {
  description = "Whether to enable threat detection policies."
  type        = bool
  default     = false
}

variable "threat_detection_disabled_alerts" {
  description = "List of alert types to disable."
  type        = list(string)
  default     = ["Sql_Injection", "Data_Exfiltration"]
}

variable "email_admins_for_alerts" {
  description = "Whether to email administrators on threat detection alerts."
  type        = bool
  default     = true
}

variable "alert_email_addresses" {
  description = "List of email addresses to send alerts to."
  type        = list(string)
  default     = []
}

variable "alert_retention_days" {
  description = "Number of days to keep threat detection alert data."
  type        = number
  default     = 30
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {
    environment = "production"
    managed_by  = "terraform"
  }
}