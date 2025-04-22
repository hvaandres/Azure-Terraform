server_name         = "sqlserver-basic-example"
resource_group_name = "example-rg"
location            = "westus2"
administrator_login = "sqladmin"
administrator_login_password = "SecurePassword!"
firewall_rules = {
  azure_services = {
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
  }
}
databases = {
  db1 = {
    name     = "sample-db"
    sku_name = "Basic"
  }
}
tags = {
  Environment = "Development"
  Project     = "Demo"
}