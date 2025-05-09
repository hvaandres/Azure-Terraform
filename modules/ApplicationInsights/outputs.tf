output "application_insights_ids" {
  description = "The IDs of the Application Insights instances"
  value = {
    for k, v in azurerm_application_insights.insights : k => v.id
  }
}

output "application_insights_instrumentation_keys" {
  description = "The Instrumentation Keys of the Application Insights instances"
  value = {
    for k, v in azurerm_application_insights.insights : k => v.instrumentation_key
  }
  sensitive = true
}

output "application_insights_connection_strings" {
  description = "The Connection Strings of the Application Insights instances"
  value = {
    for k, v in azurerm_application_insights.insights : k => v.connection_string
  }
  sensitive = true
}