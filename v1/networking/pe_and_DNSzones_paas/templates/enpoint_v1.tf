


resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_name #"privatelink.dfs.core.windows.net"
  resource_group_name = var.DNSzone_resource_group_name
  tags                = var.default_tags

}

#Private DNS zone Virtual Network Links
resource "azurerm_private_dns_zone_virtual_network_link" "link_to_vnet" {
  name = var.private_dns_zone_virtual_network_link_name
  #resource group where the Private DNS Zone exists
  resource_group_name   = var.DNSzone_resource_group_name
  private_dns_zone_name = "privatelink.dfs.core.windows.net"
  virtual_network_id    = var.virtual_network_id
}

module "pv_enpoint_exp1" {
  source = "../"
  #name
  Clientname       = "hayago"
  workload         = "keyvault"
  environment_type = "dev"
  location_short   = "sea"
  number_instance  = "001"


  #private endpoint
  Private_endpoint_resource_group_name = ""
  subnet_id                            = ""
  region                               = "southeastasia"


  # private dns_zone 
  private_dns_zone_id = ""

  # private services connection
  is_manual_connection           = "false"
  private_connection_resource_id = ""
  subresource_names              = ""
  request_message                = ""

  default_tags = ""

}



