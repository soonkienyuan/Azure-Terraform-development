# names for Synapse workspace

resource "azurecaf_name" "SynapseWorkspce_name" {
  name          = var.owner
  resource_type = "azurerm_synapse_workspace"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}
#name for managed resource group
resource "azurecaf_name" "managed_resource_group_name" {
  name          = var.owner
  resource_type = "azurerm_resource_group"
  suffixes      = ["SynapsedManaged", var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

resource "azurerm_synapse_workspace" "workspace" {
  #--------------------basic------------------------------------------------------------------------
  resource_group_name         = var.resource_group_name
  managed_resource_group_name = azurecaf_name.managed_resource_group_name.result
  name                        = azurecaf_name.SynapseWorkspce_name.result
  location                    = var.region

  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id

  #--------------------security------------------------------------------------------------------------
  azuread_authentication_only = var.azuread_authentication_only

  # if azuerad_authentication_only = false, then Use both local and Microsoft Entra ID authentication
  sql_administrator_login          = var.sql_administrator_login
  sql_administrator_login_password = try(var.sql_administrator_login_password, random_password.sql_admin.0.result)
  #System assigned managed identity permission
  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "SystemAssigned" ? null : var.user_assign_identities_id
  }
  #  #Workspace encryption
  #need keyvault purge_proctection to enable double encryption and same region
  #keyvault RBAC - workspaces managed identity applicatoinOnly - do not add it as an authorized application
  customer_managed_key {
    key_versionless_id = var.double_encryption_key_versionless_id
    key_name           = var.double_encryption_key_name
  }

  # ----------------networking-------------- ----------------------------------------------------------
  data_exfiltration_protection_enabled = var.data_exfiltration_protection_enabled
  #managed_virtual_network_id
  #refer to azurerm_synapse_firewall_rule and azurerm_synapse_managed_private_endpoint
  managed_virtual_network_enabled = var.data_exfiltration_protection_enabled ? true : try(var.managed_virtual_network_enabled, null)
  public_network_access_enabled   = var.public_network_access_enabled




}
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The Azure feature Allow access to Azure services can be enabled 
by setting start_ip_address and end_ip_address to 0.0.0.0.

The Azure feature Allow access to Azure services requires 
the name to be AllowAllWindowsAzureIps.
*/
resource "azurerm_synapse_firewall_rule" "workspace_firewall_rule" {
  count = var.managed_virtual_network_enabled ? 1 : 0

  name                 = var.workspace_firewall_rule_name #default AllowAllWindowsAzureIps
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  start_ip_address     = var.start_ip_address #default 0.0.0.0
  end_ip_address       = var.end_ip_address   #default 0.0.0.0
}

#create managed private endpoint


#Microsoft Entra ID admin

/*When using Microsoft Entra authentication, 
there are two Administrator accounts for the Synapse SQL;
the original SQL administrator (using SQL authentication) 
and the Microsoft Entra administrator.

The Microsoft Entra admin account controls access to dedicated pools, 
while Synapse RBAC roles are used to control access to serverless pools, 
for example, with the Synapse Administrator and Synapse SQL Administrator role. 
Configure Synapse RBAC roles via Synapse Studio, for more information 
*/

# -----------Generate sql server random admin password if not provided in the attribute administrator_login_password---------------------
resource "random_password" "sql_admin" {
  count = try(var.sql_administrator_login_password, null) == null ? 1 : 0

  length           = 30
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "$#%"
}

# ------------------Store the generated password into keyvault for password rotation support---------------------
resource "azurerm_key_vault_secret" "sql_admin_password" {
  count = try(var.sql_administrator_login_password, null) == null ? 1 : 0

  name         = format("%s-synapse-sql-admin-password", azurerm_synapse_workspace.workspace.name)
  value        = random_password.sql_admin.0.result
  key_vault_id = var.keyvault_id_to_store

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_key_vault_secret" "sql_admin" {
  count = try(var.sql_administrator_login_password, null) == null ? 1 : 0

  name         = format("%s-synapse-sql-admin-username", azurerm_synapse_workspace.workspace.name)
  value        = var.sql_administrator_login
  key_vault_id = var.keyvault_id_to_store
}

