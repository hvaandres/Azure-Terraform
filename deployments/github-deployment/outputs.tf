output "subscription_id" {
  description = "The ID of the Azure subscription."
  value       = data.azurerm_subscription.sub.id
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = module.ResourceGroup.resource_group_name
}

output "resource_group_location" {
  description = "The location of the resource group."
  value       = module.ResourceGroup.resource_group_location
}

output "identity_resource_group_name" {
  description = "The name of the identity resource group."
  value       = module.identity-resource-group.identity_rg_name
}

output "federated_identity_credential_id" {
  description = "The ID of the federated identity credential."
  value       = module.gh_federated_credential.federated_identity_credential_id
}

output "federated_identity_credential_pr_id" {
  description = "The ID of the federated identity credential for pull requests."
  value       = module.gh_federated_credential-pr.federated_identity_credential_id
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.StorageAccounts.storage_account_id
}

output "storage_account_container_id" {
  description = "The ID of the storage account container."
  value       = module.StorageAccountContainer.storage_account_container_id
}