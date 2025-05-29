output "id" {
  description = "The ID of the MS SQL Database."
  value       = azurerm_mssql_database.this.id
}

output "name" {
  description = "The name of the MS SQL Database."
  value       = azurerm_mssql_database.this.name
}

output "server_id" {
  description = "The ID of the MS SQL Server."
  value       = azurerm_mssql_database.this.server_id
}

output "connection_string" {
  description = "The connection string for the MS SQL Database."
  value       = "Server=tcp:${split("/", azurerm_mssql_database.this.server_id)[8]}.database.windows.net,1433;Database=${azurerm_mssql_database.this.name};Encrypt=true;Connection Timeout=30;"
  sensitive   = true
}