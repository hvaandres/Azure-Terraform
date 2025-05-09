# Resource Group
resource_group_name = "sql-demo-rg"
location            = "eastus"

# SQL Server
server_name                  = "demo-sql-server"
administrator_login          = "sqladmin"
administrator_login_password = "P@ssw0rd1234!"  # Remember to use a secure password in production
public_network_access_enabled = true

# Database configuration
database_name                        = "demo-database"
collation                            = "SQL_Latin1_General_CP1_CI_AS"
license_type                         = "LicenseIncluded"
max_size_gb                          = 50
sku_name                             = "GP_Gen5_2"
zone_redundant                       = false
read_scale                           = false
storage_account_type                 = "Geo"
transparent_data_encryption_enabled  = true

# Threat Detection Policy
enable_threat_detection_policy       = true

# Tags
tags = {
  Environment = "Development"
  Department  = "IT"
  Project     = "SQL Demo"
  Owner       = "Database Team"
}