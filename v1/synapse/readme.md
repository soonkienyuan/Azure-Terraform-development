

## create synapse workspace

1. create storage account
2. create data lake gen 2
3. workspace

## Enabled double encryption workspace

1. create key vault

   ```
   resource "azurerm_key_vault" "example" {
     name                     = "example"
     location                 = azurerm_resource_group.example.location
     resource_group_name      = azurerm_resource_group.example.name
     tenant_id                = data.azurerm_client_config.current.tenant_id
     sku_name                 = "standard"
     purge_protection_enabled = true
   }
   ```

2. access policy to to let you create key

   ```
   resource "azurerm_key_vault_access_policy" "deployer" {
     key_vault_id = azurerm_key_vault.example.id
     tenant_id    = data.azurerm_client_config.current.tenant_id
     object_id    = data.azurerm_client_config.current.object_id
   
     key_permissions = [
       "Create", "Get", "Delete", "Purge", "GetRotationPolicy"
     ]
   }
   ```

3. create the customer managed key 

   ```
   resource "azurerm_key_vault_key" "example" {
     name         = "workspaceEncryptionKey"
     key_vault_id = azurerm_key_vault.example.id
     key_type     = "RSA"
     key_size     = 2048
     key_opts = [
       "unwrapKey",
       "wrapKey"
     ]
     depends_on = [
       azurerm_key_vault_access_policy.deployer
     ]
   }
   ```

4. create workspace, and input key into the customer_managed_key block

5. let workspace managed identities to get

6. access policy - "get", "wrapKey", "unwrapKey"

   ```
   resource "azurerm_key_vault_access_policy" "workspace_policy" {
     key_vault_id = azurerm_key_vault.example.id
     tenant_id    = azurerm_synapse_workspace.example.identity[0].tenant_id
     object_id    = azurerm_synapse_workspace.example.identity[0].principal_id
   
     key_permissions = [
       "Get", "WrapKey", "UnwrapKey"
     ]
   }
   ```

7. double encrypt it by active=true

   ```
   resource "azurerm_synapse_workspace_key" "example" {
     customer_managed_key_versionless_id = azurerm_key_vault_key.example.versionless_id
     synapse_workspace_id                = azurerm_synapse_workspace.example.id
     active                              = true
     customer_managed_key_name           = "enckey"
     depends_on                          = [azurerm_key_vault_access_policy.workspace_policy]
   }
   ```


synpase sql feature including rbac security/data format - [Synapse SQL pools](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/overview-features)

When using Microsoft Entra authentication, there are two Administrator accounts for the Synapse SQL; the original SQL administrator (using SQL authentication) and the Microsoft Entra administrator. Only the administrator based on a Microsoft Entra account can create the first Microsoft Entra ID contained database user in a user database.

[Use Microsoft Entra authentication for authentication with Synapse SQL](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/active-directory-authentication)

[How to set up access control for your Azure Synapse workspace](https://learn.microsoft.com/en-us/azure/synapse-analytics/security/how-to-set-up-access-control?source=recommendations)

To help you regain access to a workspace in the event that no Synapse Administrators are assigned or available to you, users with permissions to manage Azure RBAC role assignments on the workspace can also manage Synapse RBAC role assignments, allowing the addition of Synapse Administrator or other Synapse role assignments.
Access to SQL pools is managed using SQL permissions. With the exception of the Synapse Administrator and Synapse SQL Administrator roles, Synapse RBAC roles do not grant access to SQL pools.

-https://learn.microsoft.com/en-us/azure/synapse-analytics/security/how-to-manage-synapse-rbac-role-assignments

The Microsoft Entra administrator login can be a Microsoft Entra user or a Microsoft Entra group. When the administrator is a group account, it can be used by any group member, enabling multiple Microsoft Entra administrators for the Synapse SQL instance.

Using group account as an administrator enhances manageability by allowing you to centrally add and remove group members in Microsoft Entra ID without changing the users or permissions in Azure Synapse Analytics workspace. Only one Microsoft Entra administrator (a user or group) can be configured at any time.

[login and user Authorize database access to SQL Database, SQL Managed Instance, and Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/azure-sql/database/logins-create-manage?view=azuresql&toc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Ftoc.json)

A Microsoft Entra admin must be configured if you want to use Microsoft Entra accounts to connect to SQL Database, SQL Managed Instance, or Azure Synapse. For detailed information on enabling Microsoft Entra authentication for all Azure SQL deployment types, see the following articles:

[Use Microsoft Entra authentication with SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-overview?view=azuresql)
[Configure and manage Microsoft Entra authentication with SQL](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure?view=azuresql)

[Microsoft Entra admin by calling the following CLI commands](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure?view=azuresql&toc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Ftoc.json&tabs=azure-cli)

---------------------------------
Use Microsoft Entra authentication
- It provides an alternative to SQL Server authentication.
- Customers can manage database permissions using Microsoft Entra groups.
- Microsoft Entra authentication uses contained database users to authenticate identities at the database level.





# SQL pool

### Transparentt Data Encryption

https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-encryption-tde-tsql?source=recommendations