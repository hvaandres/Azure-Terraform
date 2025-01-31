data "azurerm_subscription" "sub" {
}

data "azurerm_resource_group" "tfstate" {
  name = "tfstate"
}

# Resource Group module
module "resource_groups" {
  source   = "./modules/ContainerRegistry"
  resource_groups = var.resource_groups
}

# User Assigned Identity module
module "user_assigned_identities" {
  source   = "./modules/UserAssignedIdentity"
  for_each = var.user_assigned_identity
  user_assigned_identity_name = each.value.user_assigned_identity_name
  resource_group_name = each.value.resource_group_name
  location = each.value.location
}

module "storage_accounts" {
  source = "./modules/StorageAccounts"
  storage_accounts = var.storage_accounts
  depends_on = [module.resource_groups]
}

module "storage_account_containers" {
  source = "./modules/StorageAccounts"
  storage_accounts = var.storage_account_containers
  storage_account_containers = var.storage_account_containers
  depends_on = [module.storage_accounts]
}

# Federated Identity Credential module
module "federated_identity_credentials" {
  source = "./modules/FederatedIdentityCredential"
  federated_credentials = var.federated_credentials
  depends_on = [module.user_assigned_identities]
}

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