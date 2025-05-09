# Server reference information
existing_server_name         = "my-sql-server"
existing_resource_group_name = "my-resource-group"

# Database configuration
database_name                         = "my-database"
collation                             = "SQL_Latin1_General_CP1_CI_AS"
license_type                          = "LicenseIncluded"
max_size_gb                           = 50
sku_name                              = "GP_Gen5_2"
zone_redundant                        = false
read_scale                            = false
storage_account_type                  = "Geo"
transparent_data_encryption_enabled   = true

# Backup and retention policies
backup_retention_days                 = 7
enable_long_term_retention            = true
weekly_retention                      = "P4W"
monthly_retention                     = "P12M"
yearly_retention                      = "P5Y"
week_of_year                          = 1
geo_backup_enabled                    = true

# Threat detection
enable_threat_detection               = true
threat_detection_disabled_alerts      = ["Sql_Injection", "Data_Exfiltration"]
email_admins_for_alerts               = true
alert_email_addresses                 = ["dba@example.com", "security@example.com"]
alert_retention_days                  = 30

# Resource tags
tags = {
  Environment = "Development"
  Department  = "IT"
  Project     = "Database Migration"
  Owner       = "Database Team"
}