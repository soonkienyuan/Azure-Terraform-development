output "subnet_ids" {
  value = {
    for subnet_name, subnet in azurerm_subnet.subnet_for_each : subnet_name => subnet.id
  }
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet_creation.id
}
