variable "name" {
  description = "The name of the MS SQL Database."
  type        = string
}

variable "server_id" {
  description = "The id of the MS SQL Server on which to create the database."
  type        = string
}

variable "collation" {
  description = "Specifies the collation of the database."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
  type        = string
  default     = null
  validation {
    condition     = var.license_type == null || contains(["LicenseIncluded", "BasePrice"], var.license_type)
    error_message = "The license_type must be either LicenseIncluded or BasePrice."
  }
}

variable "max_size_gb" {
  description = "The max size of the database in gigabytes."
  type        = number
  default     = null
}

variable "read_scale" {
  description = "If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica."
  type        = bool
  default     = false
}

variable "sku_name" {
  description = "Specifies the name of the SKU used by the database."
  type        = string
  default     = "S0"
}

variable "zone_redundant" {
  description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones."
  type        = bool
  default     = false
}

variable "auto_pause_delay_in_minutes" {
  description = "Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled."
  type        = number
  default     = null
}

variable "create_mode" {
  description = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary."
  type        = string
  default     = "Default"
  validation {
    condition     = contains(["Copy", "Default", "OnlineSecondary", "PointInTimeRestore", "Recovery", "Restore", "RestoreExternalBackup", "RestoreExternalBackupSecondary", "RestoreLongTermRetentionBackup", "Secondary"], var.create_mode)
    error_message = "The create_mode must be one of Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup or Secondary."
  }
}

variable "creation_source_database_id" {
  description = "The ID of the source database from which to create the new database."
  type        = string
  default     = null
}

variable "recover_database_id" {
  description = "The ID of the database to be recovered."
  type        = string
  default     = null
}

variable "restore_point_in_time" {
  description = "The point in time for the restore. Only applies if create_mode is PointInTimeRestore."
  type        = string
  default     = null
}

variable "storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database. Possible values are Geo, GeoZone, Local and Zone."
  type        = string
  default     = null
  validation {
    condition     = var.storage_account_type == null || contains(["Geo", "GeoZone", "Local", "Zone"], var.storage_account_type)
    error_message = "The storage_account_type must be one of Geo, GeoZone, Local or Zone."
  }
}

variable "transparent_data_encryption_enabled" {
  description = "Whether or not this database is using transparent data encryption."
  type        = bool
  default     = true
}

variable "threat_detection_policy" {
  description = "Threat detection policy configuration."
  type = object({
    state                      = string
    disabled_alerts            = optional(list(string))
    email_account_admins       = optional(bool)
    email_addresses            = optional(list(string))
    retention_days             = optional(number)
    storage_account_access_key = optional(string)
    storage_endpoint           = optional(string)
  })
  default = null
}

variable "short_term_retention_policy" {
  description = "Short Term Retention Policy configuration."
  type = object({
    retention_days = number
  })
  default = null
}

variable "long_term_retention_policy" {
  description = "Long Term Retention Policy configuration."
  type = object({
    weekly_retention  = optional(string)
    monthly_retention = optional(string)
    yearly_retention  = optional(string)
    week_of_year      = optional(number)
  })
  default = null
}

variable "geo_backup_policy" {
  description = "Geo Backup Policy configuration."
  type = object({
    state = string
  })
  default = null
  validation {
    condition     = var.geo_backup_policy == null || contains(["Enabled", "Disabled"], var.geo_backup_policy.state)
    error_message = "The geo_backup_policy state must be either Enabled or Disabled."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}