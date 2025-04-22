# Basic example with server and one databasemodule 

module "sql_server_basic" {
  source              = "./modules/azure-mssql-complete"
  server_name         = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  administrator_login = var.administrator_login
  administrator_login_password = var.administrator_login_password

  # Allow Azure services to access the server
  firewall_rules = var.firewall_rules

  # Create a single basic database
  databases = var.databases

  tags = var.tags
}