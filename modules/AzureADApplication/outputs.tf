output "service_principal_object_id" {
  description = "The object ID of the service principal"
  value       = azuread_service_principal.az-service-principal.object_id
}

output "service_principal_application_id" {
  description = "The application ID of the service principal"
  value       = azuread_service_principal.az-service-principal.application_id
}

output "service_principal_display_name" {
  description = "The display name of the service principal"
  value       = azuread_service_principal.az-service-principal.display_name
}