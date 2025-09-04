#name for private endpoint
resource "azurecaf_name" "private_endpoint_name" {
  name          = var.owner
  resource_type = "azurerm_private_endpoint"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}
#name for private dns zone group
resource "azurecaf_name" "private_dns_zone_group_name" {
  name          = var.owner
  resource_type = "azurerm_private_dns_zone_group"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}


#name for private services
resource "azurecaf_name" "private_service_name" {
  name          = var.owner
  resource_type = "azurerm_private_service_connection"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}


resource "azurerm_private_endpoint" "private_endpoint" {
  resource_group_name = var.Private_endpoint_resource_group_name

  name      = azurecaf_name.private_endpoint_name.result
  location  = var.region
  subnet_id = var.subnet_id


  tags = var.default_tags

  private_service_connection {
    name                           = azurecaf_name.private_service_name.result
    is_manual_connection           = var.is_manual_connection
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
    request_message                = var.request_message
  }

  private_dns_zone_group {
    name                 = azurecaf_name.private_dns_zone_group_name.result
    private_dns_zone_ids = var.private_dns_zone_id
  }
  depends_on = [azurerm_private_dns_zone.private_dns_zone]
}




