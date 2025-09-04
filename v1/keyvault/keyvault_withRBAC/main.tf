
# # can be call to retrieved oid, tid, subid, clienid if azure_rbac is not used
# data "azurerm_client_config" "current" {}



resource "azurecaf_name" "key_vault_name" {
  name          = var.owner
  resource_type = "azurerm_key_vault"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}


resource "azurerm_key_vault" "key_vault_creation" {

  #required fields
  resource_group_name = var.resource_group_name
  name                = azurecaf_name.key_vault_name.result
  location            = var.region
  sku_name            = var.sku_name
  tenant_id           = var.tenant_id

  #optional fields
  #Resource access to specific resources
  #Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.
  enabled_for_deployment      = var.enabled_for_deployment
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  #Resource Manager is permitted to retrieve secrets from the key vault?  
  enabled_for_template_deployment = var.enabled_for_template_deployment

  #enable azure rbac?
  enable_rbac_authorization = var.enable_rbac_authorization

  #Once Purge Protection has been Enabled it's not possible to Disable it. 
  #Key Vault to be deleted 90days
  purge_protection_enabled = var.purge_protection_enabled
  #int : number of days that items should be retained for once soft-deleted
  soft_delete_retention_days = var.soft_delete_retention_days


  public_network_access_enabled = var.public_network_access_enabled
  network_acls {
    bypass                     = var.bypass                     # None or "AzureServices"
    default_action             = var.default_action             # Deny or Allow
    ip_rules                   = var.ip_rules                   # List of IP addresses or CIDR ranges to access keyvault
    virtual_network_subnet_ids = var.virtual_network_subnet_ids #Subnet IDs which should be able to access this Key Vault.

  }
}
#If rbac = true, then traditional access policy (get, list, deleted .....) will not used
#if rbac = false, then user can configure access policy on portal


# resource "azurerm_key_vault_access_policy" "access_policy_key_vault" {
#   count        = var.enable_rbac_authorization ? 0 : 1
#   key_vault_id = azurerm_key_vault.key_vault_creation.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_client_config.current.object_id

#   dynamic "" {

#   }

# }
