# terraform.tfvars.example - Users can customize their lab environment

# Basic configuration
prefix               = "mylab"
resource_group_name  = "rg-pentest-lab"
location            = "East US"

# Custom VM configuration - Add/remove/modify VMs as needed
vms = {
  # Kali Linux VM
  kali = {
    name           = "kali01"
    size           = "Standard_D4s_v3"  # Larger size for intensive tasks
    admin_username = "kaliuser"
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
  
  # Windows 11 Target
  win11 = {
    name           = "victim-w11"
    size           = "Standard_D2s_v3"
    admin_username = "localadmin"
    os_type        = "windows"
    source_image_reference = {
      publisher = "MicrosoftWindowsDesktop"
      offer     = "Windows-11"
      sku       = "win11-24h2-pro"
      version   = "latest"
    }
    enable_aad_login = true
  },
  
  # Add Ubuntu VM for additional Linux testing
  ubuntu = {
    name           = "ubuntu01"
    size           = "Standard_B2s"
    admin_username = "azureuser"
    os_type        = "linux"
    disable_password_authentication = false
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
    enable_policy_extension = true
  },
  
  # Windows Server target
  winserver = {
    name           = "winsrv01"
    size           = "Standard_D2s_v3"
    admin_username = "srvadmin"
    os_type        = "windows"
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-g2"
      version   = "latest"
    }
    enable_aad_login = true
  }
}

# Custom subnet configuration
subnets = {
  vm_subnet = {
    name             = "targets-subnet"
    address_prefixes = ["10.0.1.0/24"]
  },
  bastion_subnet = {
    name             = "AzureBastionSubnet"
    address_prefixes = ["10.0.2.0/26"]
  },
  # Add a DMZ subnet for additional isolation
  dmz_subnet = {
    name             = "dmz-subnet"
    address_prefixes = ["10.0.3.0/24"]
  }
}

# Enhanced NSG rules for penetration testing
nsg_rules = [
  # Bastion required rules
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
    name                       = "AllowGatewayManagerInbound"
    priority                   = 101
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
    name                       = "AllowBastionHostCommunication"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = null
    destination_port_ranges    = ["8080", "5701"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  
  # Lab-specific rules for penetration testing
  {
    name                       = "AllowWebTrafficInternal"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = null
    destination_port_ranges    = ["80", "443", "8080", "8443"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "AllowCommonPortsInternal"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = null
    destination_port_ranges    = ["21", "22", "23", "25", "53", "110", "143", "993", "995"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "AllowDatabasePortsInternal"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = null
    destination_port_ranges    = ["1433", "3306", "5432", "1521"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  
  # Outbound rules
  {
    name                       = "AllowAzureCloudOutbound"
    priority                   = 100
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
    name                       = "AllowBastionCommunicationOutbound"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = null
    destination_port_ranges    = ["22", "3389", "8080", "5701"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "AllowInternetOutbound"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = null
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
]

# Bastion configuration
bastion_config = {
  sku                    = "Standard"
  shareable_link_enabled = true
  tunneling_enabled      = true
  ip_connect_enabled     = true
  scale_units           = 2  # Adjust based on expected concurrent connections
}