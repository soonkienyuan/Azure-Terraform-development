# using the azurecaf_name resource, follow the CAF naming convention


resource "azurecaf_name" "resource_group" {
  name          = var.owner
  resource_type = "azurerm_resource_group"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

resource "azurerm_resource_group" "rg-creation" {
  name     = azurecaf_name.resource_group.result
  location = var.region
  tags     = var.default_tag
}
