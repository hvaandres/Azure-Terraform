resource "azuread_application" "az-ad-app" {
  for_each = var.applications

  display_name     = each.value.display_name
  sign_in_audience = each.value.sign_in_audience

  dynamic "web" {
    for_each = each.value.redirect_uris != null ? [1] : []
    content {
      redirect_uris = each.value.redirect_uris
    }
  }

  optional_claims {
    dynamic "access_token" {
      for_each = each.value.optional_claims_access_token != null ? each.value.optional_claims_access_token : []
      content {
        name = access_token.value
      }
    }
  }

  tags = each.value.tags
}

resource "azuread_service_principal" "az-ad-sp" {
  for_each = azuread_application.az-ad-app

  client_id               = each.value.application_id
  app_role_assignment_required = false
  owners                  = [data.azuread_client_config.current.object_id]

  feature_tags {
    enterprise = true
    gallery    = false
  }
}