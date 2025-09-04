resource "azurecaf_name" "publicIP" {
  name          = var.private_dns_zone_group_name
  resource_type = "azurerm_public_ip"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

# public IP

resource "azurerm_public_ip" "publicIP_bastion" {
  name                = azurecaf_name.publicIP.result
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.pip_sku
}
