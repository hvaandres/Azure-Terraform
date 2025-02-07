locals {
  default_audience_name = "api://AzureADTokenExchange"
  github_issuer_url     = "https://token.actions.githubusercontent.com"
  # role_assignments = {
  #   for key, value in var.role_assignments : key => merge(value, {
  #     principal_id = try(module.user_assigned_identity.principal_ids[key], value.principal_id, ""),
  #     role_definition_id = try(data.azurerm_role_definition.example.id, value.role_definition_id, "")
  #   })
  # }
}