variable "network_security_groups" {
  description = "Map of NSGs to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules = map(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                         = optional(string)
      source_port_ranges                        = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      description                               = optional(string)
    }))
    tags = optional(map(string))
  }))

  default = {
    "web_nsg" = {
      name                = "web-nsg"
      location            = "East US"
      resource_group_name = "example-resources"
      security_rules = {
        "allow_http" = {
          name                       = "allow-http"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range         = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          description               = "Allow HTTP traffic"
        }
      }
      tags = {
        environment = "Production"
        purpose     = "Web"
      }
    }
    "app_nsg" = {
      name                = "app-nsg"
      location            = "East US"
      resource_group_name = "example-resources"
      security_rules = {
        "allow_https" = {
          name                       = "allow-https"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range         = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          description               = "Allow HTTPS traffic"
        }
      }
      tags = {
        environment = "Production"
        purpose     = "Application"
      }
    }
    "db_nsg" = {
      name                = "db-nsg"
      location            = "East US"
      resource_group_name = "example-resources"
      security_rules = {
        "allow_sql" = {
          name                        = "allow-sql"
          priority                    = 120
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "Tcp"
          source_port_ranges          = ["1433", "1434"]
          destination_port_ranges     = ["1433"]
          source_address_prefixes     = ["10.0.0.0/24", "192.168.1.0/24"]
          destination_address_prefixes = ["10.0.1.0/24"]
          description                = "Allow SQL traffic from specific networks"
        }
      }
      tags = {
        environment = "Production"
        purpose     = "Database"
      }
    }
  }
}
