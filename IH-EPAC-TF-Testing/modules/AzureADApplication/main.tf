resource "azuread_application" "az-application" {
  display_name = var.base_name_app
}

resource "azuread_service_principal" "az-service-principal" {
  client_id      = azuread_application.az-application.application_id
}