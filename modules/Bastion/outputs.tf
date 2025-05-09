output "bastion_host_ids" {
  description = "The IDs of the Bastion Hosts"
  value = {
    for k, v in azurerm_bastion_host.bastion : k => v.id
  }
}

output "bastion_host_fqdns" {
  description = "The FQDNs of the Bastion Hosts"
  value = {
    for k, v in azurerm_bastion_host.bastion : k => v.dns_name
  }
}