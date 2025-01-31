output "federated_identity_credential_id" {
  description = "The ID of the federated identity credential."
  value       = azurerm_federated_identity_credential.cred.id
}

output "federated_identity_credential_name" {
  description = "The name of the federated identity credential."
  value       = azurerm_federated_identity_credential.cred.name
}

output "federated_identity_credential_audience" {
  description = "The audience of the federated identity credential."
  value       = azurerm_federated_identity_credential.cred.audience
}

output "federated_identity_credential_issuer" {
  description = "The issuer URL of the federated identity credential."
  value       = azurerm_federated_identity_credential.cred.issuer
}

output "federated_identity_credential_subject" {
  description = "The subject of the federated identity credential."
  value       = azurerm_federated_identity_credential.cred.subject
}