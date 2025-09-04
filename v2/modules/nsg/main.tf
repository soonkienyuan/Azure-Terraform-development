resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsg_name_configs

  name                = "nsg-${var.project_name}-${each.value.workload}-${each.value.environment}-${each.value.location_abb}-${each.value.instance}"
  location            = each.value.location
  resource_group_name = var.resource_group_name
  tags = {
    project     = var.project_name
    workload    = each.value.workload
    environment = each.value.environment
    location    = each.value.location_abb
  }
}
