output "server_fqdn" {
  description = "The fully qualified domain name of the SQL server."
  value       = module.sql_server_basic.sql_server_fqdn
}

output "database_names" {
  description = "A list of the names of the created databases."
  value       = keys(module.sql_server_basic.databases)
}