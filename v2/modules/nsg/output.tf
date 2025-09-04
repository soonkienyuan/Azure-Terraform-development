output "nsg_names" {
  description = "Map of NSG names"
  value       = { for key, nsg in azurerm_network_security_group.nsg : key => nsg.name }
}
output "nsg_ids" {
  description = "Map of NSG ids"
  value       = { for key, nsg in azurerm_network_security_group.nsg : key => nsg.id }
}
