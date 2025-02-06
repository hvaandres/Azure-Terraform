data "azurerm_subscription" "sub" {
}

# data "azurerm_resource_group" "tfstate" {
#   name = "tfstate"
# }

// Roles
data "azurerm_role_definition" "example" {
  name = "Storage Blob Data Contributor"
}

locals {
  role_assignments = {
    for key, value in var.role_assignments : key => merge(value, {
      principal_id = module.user_assigned_identity.principal_ids[key],
      role_definition_id = data.azurerm_role_definition.example.id
    })
  }
}


# Resource Group module
module "resource_groups" {
  source   = "./modules/ResourceGroup"
  resource_groups = var.resource_groups
}

# User Assigned Identity module
module "user_assigned_identity" {
  source = "./modules/UserAssignedIdentity"
  user_assigned_identities = var.user_assigned_identities
  depends_on = [module.resource_groups]
}

module "role_assignment" {
  source = "./modules/RoleAssignment"
  role_assignments = local.role_assignments
  depends_on = [
    module.user_assigned_identity,
    module.storage_accounts
  ]
}

module "storage_accounts" {
  source = "./modules/StorageAccounts"
  storage_accounts = var.storage_accounts
  depends_on = [module.resource_groups]
}

module "storage_account_containers" {
  source = "./modules/StorageAccounts"
  storage_accounts = var.storage_accounts
  depends_on = [module.storage_accounts]
}

# # Federated Identity Credential module
# module "federated_identity_credentials" {
#   source = "./modules/FederatedIdentityCredential"
#   federated_credentials = var.federated_credentials
#   depends_on = [module.user_assigned_identities]
# }

# module "container_registries" {
#   source = "../modules/ContainerRegistry"
#   container_registries = var.container_registries
#   depends_on = [module.resource_groups]
# }

# module "kubernetes_clusters" {
#   source = "../modules/KubernetesCluster"
#   kubernetes_clusters = var.kubernetes_clusters
#   depends_on = [module.resource_groups]
# }