terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}


data "azurerm_subscription" "sub" {
}

provider "azurerm" {
  features {
  }
  subscription_id = "${var.subscription_id}"
}

module "ResourceGroup" {
    source = "./ResourceGroup"
    base_name = var.base_name
    location = var.location
}

module "identity-resource-group" {
  source           = "./IdentityResourceGroup"
  identity_rg_name = var.identity_rg_name
  location         = var.location
}

module "gh_usi" {
  source = "./UserAssignedIdentity"
  location = var.location
  name = var.name_identity
  rg_name = module.identity-resource-group.identity_rg_name
  tags = var.tags
  
}

module "sub_owner_role_assignment" {
  source         = "./RoleAssignment"
  principal_id   = module.gh_usi.user_assinged_identity_principal_id
  role_name      = var.owner_role_name
  scope_id       = data.azurerm_subscription.sub.id
}

module "gh_federated_credential" {
  source                             = "./FederatedIdentityCredential"
  federated_identity_credential_name = "${var.github_organization_target}-${var.github_repository}-${var.environment}"
  rg_name                            = module.identity-resource-group.identity_rg_name
  user_assigned_identity_id          = module.gh_usi.user_assinged_identity_id
  subject                            = "repo:${var.github_organization_target}/${var.github_repository}:environment:${var.environment}"
  audience_name                      = local.default_audience_name
  issuer_url                         = local.github_issuer_url
}

module "gh_federated_credential-pr" {
  source                             = "./FederatedIdentityCredential"
  federated_identity_credential_name = "${var.github_organization_target}-${var.github_repository}-pr"
  rg_name                            = module.identity-resource-group.identity_rg_name
  user_assigned_identity_id          = module.gh_usi.user_assinged_identity_id
  subject                            = "repo:${var.github_organization_target}/${var.github_repository}:pull_request"
  audience_name                      = local.default_audience_name
  issuer_url                         = local.github_issuer_url
}


module "tfstate_role_assignment" {
  source         = "./RoleAssignment"
  principal_id   = module.gh_usi.user_assinged_identity_principal_id
  role_name      = "Storage Blob Data Contributor"
  scope_id       = module.StorageAccounts.storage_account_id
  
}

module "StorageAccounts" {
    source = "./StorageAccounts"
    base_name = var.base_name_storage
    resource_group_name = module.ResourceGroup.resource_group_name
    location = module.ResourceGroup.resource_group_location
}

module "StorageAccountContainer" {
  source = "./StorageAccountContainer"
  base_name_container = var.base_name_container
  storage_account_id  = module.StorageAccounts.storage_account_id
}

# module "NetworkSecurityGroup" {
#   source = "./NetwrokSecurityGroup"
#   base_name_network_security_group = var.base_name_network_security_group
#   location = var.location
#   resource_group_name = module.ResourceGroup.resource_group_name
# }

# module "VirtualNetwork" {
#   source                = "./VirtualNetwork"
#   base_name_vnet   = var.base_name_vnet
#   resource_group_name   = module.ResourceGroup.resource_group_name
#   location              = var.location
#   address_space         = ["10.0.0.0/16"]
#   dns_servers           = ["10.0.0.4", "10.0.0.5"]
#   subnet_name           = "subnet1"
#   subnet_address_prefix = "10.0.2.0/24"
# }