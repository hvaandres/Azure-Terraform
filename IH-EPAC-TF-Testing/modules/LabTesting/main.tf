# variables.tf - Add these variables to your existing variables file

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = {
    vm_subnet = {
      name             = "vm-subnet"
      address_prefixes = ["10.0.1.0/24"]
    },
    bastion_subnet = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.0.2.0/26"]
    }
  }
}

variable "nsg_rules" {
  description = "List of NSG rules to create"
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = string
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = string
    destination_address_prefix   = string
  }))
  
  default = [
    {
      name                       = "AllowHttpsInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = null
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowAzureLoadBalancerInbound"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = null
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowAzureGatewayManagerInbound"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = null
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowBastionInbound"
      priority                   = 103
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = null
      destination_port_ranges    = ["5701", "8080"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowSshRdpOutbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = null
      destination_port_ranges    = ["22", "3389"]
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name                       = "AllowAzureCloudOutbound"
      priority                   = 101
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = null
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    },
    {
      name                       = "AllowBastionHostCommunicationOutbound"
      priority                   = 102
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "80"
      destination_port_ranges    = null
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    },
    {
      name                       = "AllowHttpOutbound"
      priority                   = 103
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = null
      destination_port_ranges    = ["5701", "8080"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  ]
}

variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    name                            = string
    size                           = string
    admin_username                 = string
    os_type                        = string # "linux" or "windows"
    disable_password_authentication = optional(bool, false)
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    plan = optional(object({
      name      = string
      publisher = string
      product   = string
    }))
    enable_aad_login               = optional(bool, false)
    enable_policy_extension        = optional(bool, false)
  }))
  
  default = {
    kali = {
      name           = "kali01"
      size           = "Standard_D2s_v3"
      admin_username = "azureuser"
      os_type        = "linux"
      disable_password_authentication = false
      source_image_reference = {
        publisher = "kali-linux"
        offer     = "kali"
        sku       = "kali-2024-2"
        version   = "latest"
      }
      plan = {
        name      = "kali-2024-2"
        publisher = "kali-linux"
        product   = "kali"
      }
      enable_policy_extension = true
    },
    win11 = {
      name           = "w11"
      size           = "Standard_D2s_v3"
      admin_username = "azureuser"
      os_type        = "windows"
      source_image_reference = {
        publisher = "MicrosoftWindowsDesktop"
        offer     = "Windows-11"
        sku       = "win11-24h2-pro"
        version   = "latest"
      }
      enable_aad_login = true
    },
    win10 = {
      name           = "w10"
      size           = "Standard_D2s_v3"
      admin_username = "azureuser"
      os_type        = "windows"
      source_image_reference = {
        publisher = "MicrosoftWindowsDesktop"
        offer     = "Windows-10"
        sku       = "win10-22h2-pro"
        version   = "latest"
      }
      enable_aad_login = true
    },
    rhel = {
      name           = "rhel"
      size           = "Standard_D2s_v3"
      admin_username = "azureuser"
      os_type        = "linux"
      disable_password_authentication = false
      source_image_reference = {
        publisher = "RedHat"
        offer     = "RHEL"
        sku       = "9-lvm-gen2"
        version   = "latest"
      }
      enable_policy_extension = true
    }
  }
}

variable "bastion_config" {
  description = "Bastion host configuration"
  type = object({
    sku                    = optional(string, "Standard")
    shareable_link_enabled = optional(bool, true)
    tunneling_enabled      = optional(bool, true)
    ip_connect_enabled     = optional(bool, true)
    scale_units           = optional(number, 3)
  })
  default = {}
}

# main.tf - Dynamic infrastructure

/**
 * Pentesting Lab Infrastructure Module
 * 
 * This module creates a lab environment with:
 * - Configurable VMs (Kali Linux, Windows 11, Windows 10, RHEL, etc.)
 * - All VMs in the same VNet for network connectivity
 * - Azure Bastion for secure access
 * - Entra ID (Azure AD) integration for authentication
 * - Dynamic NSG rules and subnet configuration
 */

# Resource Group
resource "azurerm_resource_group" "pentest_lab" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "pentest_vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.pentest_lab.location
  resource_group_name = azurerm_resource_group.pentest_lab.name
}

# Dynamic Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.pentest_lab.name
  virtual_network_name = azurerm_virtual_network.pentest_vnet.name
  address_prefixes     = each.value.address_prefixes
}

# Public IP for Bastion
resource "azurerm_public_ip" "bastion_ip" {
  name                = "${var.prefix}-bastion-ip"
  location            = azurerm_resource_group.pentest_lab.location
  resource_group_name = azurerm_resource_group.pentest_lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "lab_bastion" {
  name                   = "${var.prefix}-bastion"
  location               = azurerm_resource_group.pentest_lab.location
  resource_group_name    = azurerm_resource_group.pentest_lab.name
  sku                    = var.bastion_config.sku
  shareable_link_enabled = var.bastion_config.shareable_link_enabled
  tunneling_enabled      = var.bastion_config.tunneling_enabled
  ip_connect_enabled     = var.bastion_config.ip_connect_enabled
  scale_units           = var.bastion_config.scale_units

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnets["bastion_subnet"].id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}

# Dynamic Network Security Group
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.prefix}-vm-nsg"
  location            = azurerm_resource_group.pentest_lab.location
  resource_group_name = azurerm_resource_group.pentest_lab.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefix        = security_rule.value.source_address_prefix
      destination_address_prefix   = security_rule.value.destination_address_prefix
    }
  }
}

# Associate NSG with VM subnet
resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg" {
  subnet_id                 = azurerm_subnet.subnets["vm_subnet"].id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# NSG association with Bastion subnet
resource "azurerm_subnet_network_security_group_association" "bastion_nsg_association" {
  subnet_id                 = azurerm_subnet.subnets["bastion_subnet"].id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
  depends_on               = [azurerm_bastion_host.lab_bastion]
}

# Dynamic Network Interfaces
resource "azurerm_network_interface" "vm_nics" {
  for_each = var.vms
  
  name                = "${var.prefix}-${each.value.name}-nic"
  location            = azurerm_resource_group.pentest_lab.location
  resource_group_name = azurerm_resource_group.pentest_lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets["vm_subnet"].id
    private_ip_address_allocation = "Dynamic"
  }
}

# User Assigned Identity for VMs
resource "azurerm_user_assigned_identity" "vm_identity" {
  name                = "${var.prefix}-vm-identity"
  location            = azurerm_resource_group.pentest_lab.location
  resource_group_name = azurerm_resource_group.pentest_lab.name
}

# Dynamic Linux Virtual Machines
resource "azurerm_linux_virtual_machine" "linux_vms" {
  for_each = {
    for k, v in var.vms : k => v
    if v.os_type == "linux"
  }
  
  name                            = "${var.prefix}-${each.value.name}"
  location                        = azurerm_resource_group.pentest_lab.location
  resource_group_name             = azurerm_resource_group.pentest_lab.name
  network_interface_ids           = [azurerm_network_interface.vm_nics[each.key].id]
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = local.administrator_login_password
  disable_password_authentication = each.value.disable_password_authentication

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  dynamic "plan" {
    for_each = each.value.plan != null ? [each.value.plan] : []
    content {
      name      = plan.value.name
      publisher = plan.value.publisher
      product   = plan.value.product
    }
  }

  os_disk {
    name                 = "${var.prefix}-${each.value.name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id]
  }
}

# Dynamic Windows Virtual Machines
resource "azurerm_windows_virtual_machine" "windows_vms" {
  for_each = {
    for k, v in var.vms : k => v
    if v.os_type == "windows"
  }
  
  name                = "${var.prefix}-${each.value.name}"
  location            = azurerm_resource_group.pentest_lab.location
  resource_group_name = azurerm_resource_group.pentest_lab.name
  network_interface_ids = [
    azurerm_network_interface.vm_nics[each.key].id,
  ]
  size           = each.value.size
  admin_username = each.value.admin_username
  admin_password = local.administrator_login_password

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  os_disk {
    name                 = "${var.prefix}-${each.value.name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id]
  }

  # Install Azure AD login extension for Entra ID authentication
  dynamic "provisioner" {
    for_each = each.value.enable_aad_login ? ["aad_login"] : []
    content {
      local-exec {
        command = <<EOT
          az vm extension set \
            --resource-group ${azurerm_resource_group.pentest_lab.name} \
            --vm-name ${azurerm_windows_virtual_machine.windows_vms[each.key].name} \
            --name AADLoginForWindows \
            --publisher Microsoft.Azure.ActiveDirectory
        EOT
      }
    }
  }
}

# Dynamic Linux Policy Extensions
resource "azurerm_virtual_machine_extension" "linux_policy" {
  for_each = {
    for k, v in var.vms : k => v
    if v.os_type == "linux" && v.enable_policy_extension == true
  }
  
  name                       = "AzurePolicyforLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.linux_vms[each.key].id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationforLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  
  depends_on = [
    azurerm_linux_virtual_machine.linux_vms,
    azurerm_user_assigned_identity.vm_identity
  ]
}

# Role Assignment for VM Identity
resource "azurerm_role_assignment" "vm_identity_role" {
  scope                = azurerm_resource_group.pentest_lab.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = azurerm_user_assigned_identity.vm_identity.principal_id
}

# outputs.tf - Add these outputs
output "vm_details" {
  description = "Details of created VMs"
  value = merge(
    {
      for k, v in azurerm_linux_virtual_machine.linux_vms : k => {
        name        = v.name
        private_ip  = azurerm_network_interface.vm_nics[k].private_ip_address
        os_type     = "linux"
        size        = v.size
      }
    },
    {
      for k, v in azurerm_windows_virtual_machine.windows_vms : k => {
        name        = v.name
        private_ip  = azurerm_network_interface.vm_nics[k].private_ip_address
        os_type     = "windows"
        size        = v.size
      }
    }
  )
}

output "bastion_fqdn" {
  description = "FQDN of the Bastion host"
  value       = azurerm_bastion_host.lab_bastion.dns_name
}

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.pentest_lab.name
}