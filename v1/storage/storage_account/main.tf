
# name for storage account
resource "azurecaf_name" "storage_name" {
  name          = var.owner
  resource_type = "azurerm_storage_account"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

resource "azurerm_storage_account" "azure_storage_account" {

  #                  ---------
  #-------------------- Basic ------------------------------------------------------------------------
  #                    ---------
  name                     = var.storage_account_name != null ? var.storage_account_name : azurecaf_name.storage_name.result
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_replication_type = var.account_replication_type
  account_tier             = var.account_tier
  account_kind             = var.account_kind



  #                    ---------
  #-------------------- Advanced ------------------------------------------------------------------------
  #                    ---------
  enable_https_traffic_only       = var.enable_https_traffic_only
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  default_to_oauth_authentication = var.default_to_oauth_authentication
  #min_tls_version             = var.tls_version
  allowed_copy_scope = var.allowed_copy_scope
  access_tier        = var.access_tier

  is_hns_enabled                   = var.enable_hns
  sftp_enabled                     = var.enable_sftp
  nfsv3_enabled                    = var.nfsv3_enabled
  cross_tenant_replication_enabled = var.blob_cross_tenant_replication_enabled
  large_file_share_enabled         = var.enable_large_file_share


  #                -----------
  #-------------------- networking ------------------------------------------------------------------------
  #                    -----------
  public_network_access_enabled = var.public_network_access_enabled
  routing {
    choice = "MicrosoftRouting" #po
  }

  #                   -------------------
  #-------------------- Data Proctection  ------------------------------------------------------------------------
  #                    -------------------
  blob_properties {
    #if container_restore_policy_days is seted
    #This must be used together with delete_retention_policy set, 
    #versioning_enabled and change_feed_enabled set to true

    dynamic "restore_policy" {

      for_each = var.enable_restore_policy ? [1] : []
      content {
        days = var.container_restore_policy_days
        #point-in-time restore for containers
      }
    }

    delete_retention_policy {
      days = var.blob_delete_retention_policy_days
    }

    versioning_enabled = var.blob_versioning_enabled
    #Enable blob change feed
    change_feed_enabled           = var.change_feed_enabled
    change_feed_retention_in_days = var.change_feed_retention_in_days
    #default_service_version   
    last_access_time_enabled = var.last_access_time_enabled

    #
    container_delete_retention_policy {
      days = var.container_delete_retention_policy_days
    }
  }

  #                    ---------------------
  #-------------------- version-level-immutability policy ------------------------------------------------------------------------
  #                    ----------------------
  /*
Enable version-level immutability support
Allows you to set time-based retention policy on the account-level
that will apply to all blob versions. Enable this feature to set 
a default policy at the account level. Without enabling this, 
you can still set a default policy at the container level or set 
policies for specific blob versions. 

=========================================================
=Versioning is required for this property to be enabled.=
=========================================================
*/

  # no terraform code yet



  #                    ---------------------
  #-------------------- account-level-immutability policy ------------------------------------------------------------------------
  #                    ----------------------
  /*
Default account-level immutability policy 
applies to all object in sa that do not possess an 
explicit immutability policy at the object level
object-level immutability policy has 
higher precedence than the container-level immutabilit
which, higher precedence than the account-level immutability policy.

== state == 
Disabled
The policy is not active, and no immutability restrictions 
are applied to the container.

Unlocked
The policy is active, but the immutability retention 
time can be increased or decreased, and the 
allowProtectedAppendWrites property can be toggled.

Locked
The policy is active and locked. The 
immutability retention time can only be increased, 
not decreased, and the allowProtectedAppendWrites 
property cannot be changed.

== allow_protected_append_writes ==
new blocks can be written to an append blob while 
maintaining immutability protection and compliance. 
Only new blocks can be added and any existing blocks 
cannot be modified or deleted.


*/

  # # account-level immutability policy / worm

  dynamic "immutability_policy" {
    for_each = var.enable_immutability_policy == true ? [1] : []
    content {
      allow_protected_append_writes = var.allow_protected_append_writes
      state                         = var.immutability_policy_state
      #The immutability period for the blobs in the container since the policy creation, in days.
      period_since_creation_in_days = var.blob_immutability_policy_days_since_creation
    }
  }
  # immutability_policy {
  #   allow_protected_append_writes = var.allow_protected_append_writes
  #   state                         = var.immutability_policy_state
  #   #The immutability period for the blobs in the container since the policy creation, in days.
  #   period_since_creation_in_days = var.blob_immutability_policy_days_since_creation
  # }



  #                   -------------
  #-------------------- Security  ------------------------------------------------------------------------
  #                   -------------
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  #https://learn.microsoft.com/en-gb/azure/storage/common/account-encryption-key-create?tabs=template
  queue_encryption_key_type = var.queue_encryption_key_type # "Account" or "Service"
  table_encryption_key_type = var.table_encryption_key_type # "Account" or "Service" account-Azure Key Vault, mircosoft

  customer_managed_key {
    key_vault_key_id          = var.key_vault_key_id
    user_assigned_identity_id = var.user_assign_identities_id_to_encrypt
  }

  #                   -------------
  #--------------------  others/identities  ------------------------------------------------------------------------
  #                   -------------
  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "SystemAssigned" ? null : var.user_assign_identities_id
  }

  tags = var.default_tag

  depends_on = [azurecaf_name.storage_name]
}

#                    ---------------
#--------------------encryption scope------------------------------------------------------------------------------------------------
#                    ---------------

# adls2

# # name for adls2
# resource "azurecaf_name" "adls2_name" {
#   name          = var.Client_name
#   resource_type = "azurerm_storage_data_lake_gen2_filesystem"
#   suffixes      = [var.environment_type, var.location_short, var.number_instance]
#   clean_input   = true
# }

# resource "azurerm_storage_data_lake_gen2_filesystem" "adls2" {
#   storage_account_id = azurerm_storage_account.azure_storage_account.id
#   name               = azurecaf_name.adls2_name.result
# }


