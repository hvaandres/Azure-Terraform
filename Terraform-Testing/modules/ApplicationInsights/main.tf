resource "azurerm_application_insights" "insights" {
  for_each = var.application_insights

  # Required fields
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  application_type    = each.value.application_type

  # Optional fields
  tags = each.value.tags

  # Workspace configuration
  workspace_id = each.value.workspace_id

  # Retention configuration
  retention_in_days = each.value.retention_in_days

  # Daily data cap
  daily_data_cap_in_gb = each.value.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = each.value.daily_data_cap_notifications_disabled

  # Internet ingestion and streaming
  disable_ip_masking = each.value.disable_ip_masking
  force_customer_storage_for_profiler = each.value.force_customer_storage_for_profiler

  # Sampling configuration
  sampling_percentage = each.value.sampling_percentage
}

# Optional connection string management
resource "azurerm_application_insights_connection_string" "connection_string" {
  for_each = {
    for k, v in var.application_insights : k => v
    if v.connection_string != null
  }

  name                = "${each.value.name}-connection-string"
  connection_string   = each.value.connection_string.connection_string
  application_insights_id = azurerm_application_insights.insights[each.key].id
}
