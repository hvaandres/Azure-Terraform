variable "bastion_hosts" {
  description = "Map of Azure Bastion Host configurations"
  type = map(object({
    # Required fields
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    
    # Subnet configuration
    subnet_id           = string

    # Optional fields
    tags                = optional(map(string))
    
    # IP Configuration
    ip_configuration = optional(object({
      name                 = optional(string)
      public_ip_address_id = optional(string)
      subnet_id            = optional(string)
    }))

    # Copy and Paste feature
    copy_paste_enabled  = optional(bool, true)

    # File Copy feature
    file_copy_enabled   = optional(bool, false)

    # Tunneling options
    tunneling_enabled   = optional(bool, false)

    # Scale Units
    scale_units         = optional(number, 2)

    # Shareable Link
    shareable_link_enabled = optional(bool, false)

    # Endpoint options
    private_endpoint_connection = optional(object({
      name                           = string
      private_endpoint_id            = string
      connection_state               = optional(string)
      private_link_service_id        = optional(string)
      description                    = optional(string)
    }))
  }))
  default = {}
}
