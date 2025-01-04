# terraform.tfvars

# Subscription ID
# subscription_id = ""
# General variables
base_name = "aharotest01"
location  = "West US"

# ResourceGroup module variables
base_name_rg = "aharo-test01"

# Identity Resource Group module variables
identity_rg_name = "aharo-identity-rg"

# User Assigned Identity module variables
name_identity = "aharo-identity"
tags = {
    Environment     = "Testing"
    Project         = "Terraform"
    Contact       = "Alan Haro"
    Department    = "CyberSecurity"
    Support       = "alan.haro@dev.com"
}

# Role Assignment module variables
owner_role_name = "Owner"

# GitHub Federated Credential module variables
github_organization_target = "hvaandres"
github_repository          = "azure-terraform"
environment                = "dev"

# Storage Accounts module variables
base_name_storage = "aharostorage"

# Storage Account Container module variables
base_name_container = "aharocontainer"

# Local variables (if needed)
default_audience_name = "api://AzureADTokenExchange"
github_issuer_url     = "https://token.actions.githubusercontent.com"