data "azurerm_subscription" "sub" {
}

module "ResourceGroup" {
    source = "../../modules/ResourceGroup"
    base_name = var.base_name
    location = var.location
}


module "identity-resource-group" {
  source           = "../../modules/IdentityResourceGroup"
  identity_rg_name = var.identity_rg_name
  location         = var.location
}

module "gh_usi" {
  source = "../../modules/UserAssignedIdentity"
  location = var.location
  name = var.name_identity
  rg_name = module.identity-resource-group.identity_rg_name
  tags = var.tags
  
}

module "sub_owner_role_assignment" {
  source         = "../../modules/RoleAssignment"
  principal_id   = module.gh_usi.user_assinged_identity_principal_id
  role_name      = var.owner_role_name
  scope_id       = data.azurerm_subscription.sub.id
}

module "gh_federated_credential" {
  source                             = "../../modules/FederatedIdentityCredential"
  federated_identity_credential_name = "${var.github_organization_target}-${var.github_repository}-${var.environment}"
  rg_name                            = module.identity-resource-group.identity_rg_name
  user_assigned_identity_id          = module.gh_usi.user_assinged_identity_id
  subject                            = "repo:${var.github_organization_target}/${var.github_repository}:environment:${var.environment}"
  audience_name                      = local.default_audience_name
  issuer_url                         = local.github_issuer_url
}

module "gh_federated_credential-pr" {
  source                             = "../../modules/FederatedIdentityCredential"
  federated_identity_credential_name = "${var.github_organization_target}-${var.github_repository}-pr"
  rg_name                            = module.identity-resource-group.identity_rg_name
  user_assigned_identity_id          = module.gh_usi.user_assinged_identity_id
  subject                            = "repo:${var.github_organization_target}/${var.github_repository}:pull_request"
  audience_name                      = local.default_audience_name
  issuer_url                         = local.github_issuer_url
}

module "StorageAccounts" {
  source = "../../modules/StorageAccounts"
  base_name = var.base_name_storage
  resource_group_name = module.ResourceGroup.resource_group_name
  location = module.ResourceGroup.resource_group_location
}

module "StorageAccountContainer" {
  source = "../../modules/StorageAccountContainer"
  base_name_container = var.base_name_container
  storage_account_id = module.StorageAccounts.storage_account_id
}

module "tfstate_role_assignment" {
  source         = "../../modules/RoleAssignment"
  principal_id   = module.gh_usi.user_assinged_identity_principal_id
  role_name      = "Storage Blob Data Contributor"
  scope_id       = module.StorageAccounts.storage_account_id
  
}