resource "azurerm_bastion_host" "bastion" {
  for_each = var.bastion_hosts

  # Required fields
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  # Optional tags
  tags = each.value.tags

  # IP Configuration
  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration != null ? [each.value.ip_configuration] : []
    content {
      name                 = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.public_ip_address_id
      subnet_id            = ip_configuration.value.subnet_id
    }
  }

  # Bastion feature toggles
  copy_paste_enabled     = each.value.copy_paste_enabled
  file_copy_enabled      = each.value.file_copy_enabled
  tunneling_enabled      = each.value.tunneling_enabled
  scale_units            = each.value.scale_units
  shareable_link_enabled = each.value.shareable_link_enabled
}

# Optional resource for private endpoint connection
resource "azurerm_bastion_host_private_endpoint_connection" "bastion_private_endpoint" {
  for_each = {
    for k, v in var.bastion_hosts : k => v 
    if v.private_endpoint_connection != null
  }

  name                           = each.value.private_endpoint_connection.name
  bastion_host_id                = azurerm_bastion_host.bastion[each.key].id
  private_endpoint_id            = each.value.private_endpoint_connection.private_endpoint_id
  connection_state               = each.value.private_endpoint_connection.connection_state
  private_link_service_id        = each.value.private_endpoint_connection.private_link_service_id
  description                    = each.value.private_endpoint_connection.description
}
