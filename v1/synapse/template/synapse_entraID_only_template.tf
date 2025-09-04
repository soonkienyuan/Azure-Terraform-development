# can be call to retrieved oid, tid, subid, clienid if azure_rbac is not used
data "azurerm_client_config" "current" {

}


#storage account

module "storage_for_synapse" {

  source              = "../../storage/storage_account"
  resource_group_name = "ZaidWaq"

  #basic
  region                   = local.storage_account.sa_basic_tab.location
  storage_account_name     = local.storage_account.sa_basic_tab.storage_account_name
  owner                    = local.storage_account.sa_basic_tab.owner
  workload                 = local.storage_account.sa_basic_tab.workload_name
  environment_type         = local.storage_account.sa_basic_tab.environment_name
  location_short           = local.storage_account.sa_basic_tab.location_short
  number_instance          = local.storage_account.sa_basic_tab.number_instance
  account_replication_type = local.storage_account.sa_basic_tab.account_replication_type
  account_tier             = local.storage_account.sa_basic_tab.account_tier
  account_kind             = local.storage_account.sa_basic_tab.account_kind
  #advanced
  enable_https_traffic_only             = local.storage_account.sa_advanced.enable_https_traffic_only
  allow_nested_items_to_be_public       = local.storage_account.sa_advanced.allow_nested_items_to_be_public
  shared_access_key_enabled             = local.storage_account.sa_advanced.shared_access_key_enabled
  default_to_oauth_authentication       = local.storage_account.sa_advanced.default_to_oauth_authentication
  allowed_copy_scope                    = local.storage_account.sa_advanced.allowed_copy_scope
  access_tier                           = local.storage_account.sa_advanced.acces_tier
  enable_hns                            = local.storage_account.sa_advanced.enable_hns
  enable_sftp                           = local.storage_account.sa_advanced.sftp
  nfsv3_enabled                         = local.storage_account.sa_advanced.nfsv3
  blob_cross_tenant_replication_enabled = local.storage_account.sa_advanced.blob_cross_tenant_replication_enabled
  enable_large_file_share               = local.storage_account.sa_advanced.enable_large_file_share

  #networking
  public_network_access_enabled = local.storage_account.sa_networking.public_network_access
  default_network_rule          = local.storage_account.sa_networking.default_network_rule
  access_list_of_ip             = local.storage_account.sa_networking.access_list_of_ip
  traffic_bypass                = local.storage_account.sa_networking.traffic_bypass
  virtual_network_subnet_ids    = local.storage_account.sa_networking.virtual_network_subnet_ids

  #data protection
  enable_restore_policy                  = local.storage_account.sa_data_protection.enable_restore_policy
  container_restore_policy_days          = local.storage_account.sa_data_protection.container_restore_policy_days
  blob_versioning_enabled                = local.storage_account.sa_data_protection.blob_versioning_enabled
  change_feed_enabled                    = local.storage_account.sa_data_protection.enable_change_feed
  change_feed_retention_in_days          = local.storage_account.sa_data_protection.change_feed_rentention_in_days
  last_access_time_enabled               = local.storage_account.sa_data_protection.last_access_time_tracking_enabled
  blob_delete_retention_policy_days      = local.storage_account.sa_data_protection.blob_delete_retention_policy_days
  container_delete_retention_policy_days = local.storage_account.sa_data_protection.container_delete_retention_policy

  #immutability policy
  enable_immutability_policy                   = local.storage_account.immutability_policy_sa_acc_level.enable_immutability_policy
  allow_protected_append_writes                = local.storage_account.immutability_policy_sa_acc_level.allow_protected_append_writes
  immutability_policy_state                    = local.storage_account.immutability_policy_sa_acc_level.immutability_policy_state
  blob_immutability_policy_days_since_creation = local.storage_account.immutability_policy_sa_acc_level.blob_immutability_policy_days_since_creation

  #security
  infrastructure_encryption_enabled = local.storage_account.sa_security.infrastructure_encryption_enabled

  #identities
  identity_type             = "SystemAssigned"
  user_assign_identities_id = null #no user assign identity id
}

#adls gen2

#name convention for adls gen2

resource "azurecaf_name" "SynapseWorkspce_name" {
  name          = "hayago"
  resource_type = "azurerm_storage_data_lake_gen2_filesystem"
  suffixes      = ["synapse_encryption", "dev", "sea", "001"]
  clean_input   = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storage_for_synapse" {
  name               = azurecaf_name.SynapseWorkspce_name.result
  storage_account_id = module.storage_for_synapse.id_storage_account
  # will using Azure RBAC
}

#keyvault

module "keyvault_for_double_encryption" {
  #name must be between 3 and 24 characters in length
  source = "../../keyvault/keyvault_withRBAC"
  #name
  owner            = "hayago"
  workload         = "sy"
  environment_type = "dev"
  location_short   = "sea"
  number_instance  = "008"

  #required fields
  resource_group_name             = "ZaidWaq"
  region                          = "southeastasia"
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = "false"
  enabled_for_disk_encryption     = "true"
  enabled_for_template_deployment = "false"
  enable_rbac_authorization       = "false"
  purge_protection_enabled        = "true"
  soft_delete_retention_days      = 7
  public_network_access_enabled   = "true"
  bypass                          = "AzureServices"
  default_action                  = "Deny"
  ip_rules                        = ["58.26.84.7"]
  virtual_network_subnet_ids      = []

  default_tag = {
    project     = "iac-nase"
    enviroment  = "test"
    deployed_by = "soon-terraform"

  }

}

#deployer permmsion to create key

resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = module.keyvault_for_double_encryption.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create", "Get", "Delete", "Purge", "GetRotationPolicy", "Delete", "List"
  ]
  #   secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
}

#create the key #depend on deployer permission to create key
#name convention for key

resource "azurecaf_name" "key_name" {
  name          = "hayago"
  resource_type = "azurerm_key_vault_key"
  suffixes      = ["synapse_encryption", "dev", "sea", "001"]
  clean_input   = true
}
resource "azurerm_key_vault_key" "key_for_double_encryption" {
  name         = azurecaf_name.key_name.result
  key_vault_id = module.keyvault_for_double_encryption.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "unwrapKey",
    "wrapKey"
  ]
  depends_on = [azurerm_key_vault_access_policy.deployer]
}


#synapse workspace
module "synapse_Local_n_entraID" {

  source = "../synapse_workspace_with_EntraIDOnly"
  #naming convention
  owner            = "hayago"
  workload         = "synapse"
  environment_type = "dev"
  default_tag = {
    owner       = "hayago"
    environment = "dev"
  }
  location_short  = "sea"
  number_instance = "001"

  #basic
  resource_group_name                  = "ZaidWaq"
  region                               = "southeastasia"
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.storage_for_synapse.id

  #security
  azuread_authentication_only = "true"

  #identities
  identity_type             = "SystemAssigned"
  user_assign_identities_id = null #no user assign identity id

  #workspace encryption
  double_encryption_key_versionless_id = azurerm_key_vault_key.key_for_double_encryption.versionless_id
  double_encryption_key_name           = "doublerncryptionKey"

  #networking
  data_exfiltration_protection_enabled = "true"
  managed_virtual_network_enabled      = "true"
  public_network_access_enabled        = "true"
  #Allow access to Azure services
  #fiwewall rule
  workspace_firewall_rule_name = "MyClientIP"
  start_ip_address             = "58.26.84.7"
  end_ip_address               = "58.26.84.7"

  # azure ad/ microsft EntraID

  #   login_name_SQLAAD_admin = "AzureSQLAD Admin"
  #   SQLAAD_admin_object_id  = data.azurerm_client_config.current.object_id
  #   SQLAAD_admin_tenant_id  = data.azurerm_client_config.current.tenant_id

  #   login_name_AAD_admin = "AzureAD Admin"
  #   AAD_admin_object_id  = data.azurerm_client_config.current.object_id
  #   AAD_admin_tenant_id  = data.azurerm_client_config.current.tenant_id

}

#synapse workspace permission to get, wrapkey, unwrapky
#Please include lifecycle to delete/rotate the key next time
resource "azurerm_key_vault_access_policy" "workspace_policy" {
  key_vault_id = module.keyvault_for_double_encryption.key_vault_id
  tenant_id    = module.synapse_Local_n_entraID.identity_tenant_id
  object_id    = module.synapse_Local_n_entraID.identity_principal_id

  key_permissions = [
    "Get", "WrapKey", "UnwrapKey"
  ]

  # secret_permissions = ["Get", "List"]
}


#encrypt it with active =true

resource "azurerm_synapse_workspace_key" "example" {
  customer_managed_key_versionless_id = azurerm_key_vault_key.key_for_double_encryption.versionless_id
  synapse_workspace_id                = module.synapse_Local_n_entraID.synapse_workspace_id
  active                              = true
  customer_managed_key_name           = "doublerncryptionKey" # make sure the name same with double_encryption_key_name in the workspace (customer managed key block)
  depends_on                          = [azurerm_key_vault_access_policy.workspace_policy]
}

#configure  add_admin/ ad_sql admin (tested :sqladd = add)

resource "azurerm_synapse_workspace_sql_aad_admin" "SQLEntra_id_admin" {
  synapse_workspace_id = module.synapse_Local_n_entraID.synapse_workspace_id
  login                = "EntraIDSQL Admin"
  object_id            = "aa17bf35-19b1-4ba1-bdd8-3435a6a9b384" #data.azurerm_client_config.current.object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
  depends_on           = [azurerm_synapse_workspace_key.example, module.synapse_Local_n_entraID]
}

# resource "azurerm_synapse_workspace_aad_admin" "Entra_id_admin" {
#   synapse_workspace_id = module.synapse_Local_n_entraID.synapse_workspace_id
#   login                = "EntraID Admin"
#   object_id            = "aa17bf35-19b1-4ba1-bdd8-3435a6a9b384" #data.azurerm_client_config.current.object_id
#   tenant_id            = data.azurerm_client_config.current.tenant_id

#   depends_on = [azurerm_synapse_workspace_key.example]
# }



#private endpooint 

