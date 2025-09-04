

output "vnet_id" {
  description = "vnet id"
  value       = azurerm_virtual_network.vnet.id
}
#module.vnet2.subnet_ids["subnet_name"]
output "subnet_ids" {
  description = "A map of subnet names to their IDs."
  value       = { for key, subnet in azurerm_subnet.subnets : key => subnet.id }
}
