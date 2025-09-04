

# names for bastion host, public IP 

resource "azurecaf_name" "BastionHost_name" {
  name          = var.Clientname
  resource_type = "azurerm_bastion_host"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

# Bastion host
resource "azurerm_bastion_host" "Bastion_vnet1" {
  name                   = azurecaf_name.BastionHost_name.result
  location               = var.region
  resource_group_name    = var.resource_group_name
  sku                    = var.bastion_sku
  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.file_copy_enabled
  ip_connect_enabled     = var.ip_connect_enabled
  tunneling_enabled      = var.tunneling_enabled
  shareable_link_enabled = var.shareable_link_enabled
  scale_units            = var.scale_units

  ip_configuration {
    name = "configuration"
    //if we have module to create vnet
    //call that vnet module like this : 
    //module.vnet.subnet_ids["AzureBastionSubnet"]
    //the subnet_ids is declared in the vnet module output.tf
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
}
