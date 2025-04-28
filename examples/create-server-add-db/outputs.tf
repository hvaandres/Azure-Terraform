output "database_id" {
  description = "The ID of the MS SQL Database."
  value       = module.mssql_database.database_id
}

output "database_name" {
  description = "The name of the MS SQL Database."
  value       = module.mssql_database.database_name
}

output "server_id" {
  description = "The ID of the MS SQL Server."
  value       = azurerm_mssql_server.example.id
}

output "server_name" {
  description = "The name of the MS SQL Server."
  value       = azurerm_mssql_server.example.name
}

output "server_fqdn" {
  description = "The fully qualified domain name of the MS SQL Server."
  value       = azurerm_mssql_server.example.fully_qualified_domain_name
}

output "connection_string" {
  description = "The connection string for the MS SQL Database."
  value       = "Server=tcp:${azurerm_mssql_server.example.fully_qualified_domain_name},1433;Initial Catalog=${module.mssql_database.database_name};Persist Security Info=False;User ID=${var.administrator_login};Password=${var.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.example.name
}