output "database_id" {
  description = "The ID of the MS SQL Database."
  value       = module.mssql_database.database_id
}

output "database_name" {
  description = "The name of the MS SQL Database."
  value       = module.mssql_database.database_name
}

output "server_id" {
  description = "The ID of the existing MS SQL Server."
  value       = data.azurerm_mssql_server.existing.id
}

output "server_name" {
  description = "The name of the existing MS SQL Server."
  value       = data.azurerm_mssql_server.existing.name
}

output "server_fqdn" {
  description = "The fully qualified domain name of the existing MS SQL Server."
  value       = data.azurerm_mssql_server.existing.fully_qualified_domain_name
}

output "connection_string" {
  description = "The connection string for the MS SQL Database."
  value       = "Server=tcp:${data.azurerm_mssql_server.existing.fully_qualified_domain_name},1433;Initial Catalog=${module.mssql_database.database_name};Persist Security Info=False;User ID=<username>;Password=<password>;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

output "resource_group_name" {
  description = "The resource group of the existing SQL server."
  value       = var.existing_resource_group_name
}

output "database_sku" {
  description = "The SKU of the database."
  value       = var.sku_name
}

output "backup_configuration" {
  description = "Summary of the backup configuration."
  value = {
    short_term_retention_days = var.backup_retention_days
    long_term_retention_enabled = var.enable_long_term_retention
    geo_backup_enabled = var.geo_backup_enabled
  }
}

output "security_configuration" {
  description = "Summary of security configuration."
  value = {
    transparent_data_encryption_enabled = var.transparent_data_encryption_enabled
    threat_detection_enabled = var.enable_threat_detection
  }
}