resource "azurecaf_name" "adf" {
  name          = var.owner
  resource_type = "azurerm_data_factory"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

resource "azurerm_data_factory" "adf" {

  #basic  
  name                = azurecaf_name.adf.result
  resource_group_name = var.resource_group_name
  location            = var.region
  #netowrking
  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  public_network_enabled          = var.public_network_enabled

  # advanced/encryption
  #Specifies the ID of the user assigned identity associated with the Customer Managed Key. 
  #Must be supplied if customer_managed_key_id is set.
  identity {
    type         = var.type_identity #SystemAssigned, UserAssigned, SystemAssigned, UserAssigned
    identity_ids = var.type_identity == "SystemAssigned" ? null : var.user_assign_identities_id

  }
  customer_managed_key_id = var.double_encryption_customer_managed_key_id
  #Must be supplied if customer_managed_key_id is set.
  customer_managed_key_identity_id = var.customer_managed_key_identity_id
  purview_id                       = var.purview_id
  tags                             = var.default_tag

}
