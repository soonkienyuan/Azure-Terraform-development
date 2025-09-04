
locals {
  #storage account
  storage_account = {
    #--------------------------------------------
    sa_basic_tab = {
      resource_group_name = "ZaidWaq"
      location            = "southeastasia"
      #name
      storage_account_name = null
      # if the storage account name is null, name will created based on azure caf naming convention
      #naming will based on : sa-[clien]-[workload]-[env]-[location]-[num_instance]
      owner            = "hayago"
      workload_name    = "Synapse_workspace001"
      environment_name = "dev"
      location_short   = "sea"
      number_instance  = "001"
      #storage
      account_replication_type = "LRS"       # LRS, GRS, RAGRS, ZRS
      account_tier             = "Standard"  # or premium
      account_kind             = "StorageV2" # BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2
    }                                        #--------------------------------------------
    sa_advanced = {
      enable_https_traffic_only       = "true"
      allow_nested_items_to_be_public = "false"
      shared_access_key_enabled       = "true"
      default_to_oauth_authentication = "true"
      allowed_copy_scope              = "PrivateLink" # AAD, PrivateLink
      acces_tier                      = "Hot"         # Hot, Cool, Archive
      enable_hns                      = "true"
      # sftp and nfsv3 can turn on when hns=true
      sftp                                  = "false"
      nfsv3                                 = "false"
      blob_cross_tenant_replication_enabled = "false"
      enable_large_file_share               = "false"
    } #--------------------------------------------
    sa_networking = {
      public_network_access = "true"
      #network_rules
      default_network_rule       = "Deny"
      access_list_of_ip          = ["58.26.84.7"]
      traffic_bypass             = ["None"] # None, Logging, Metrics, AzureServices
      virtual_network_subnet_ids = []
      pv_endpoint_id             = ""
    } #--------------------------------------------
    sa_data_protection = {
      # if hns turned on, container restore policy should be off
      #if container restore policy is on, change feed and blob versioning should be on
      #container_restore_policy_days=point-in-time restore for containers
      enable_restore_policy          = "false"
      container_restore_policy_days  = null
      blob_versioning_enabled        = "false"
      enable_change_feed             = "false"
      change_feed_rentention_in_days = null
      # Last access time tracking integrates
      last_access_time_tracking_enabled = "true"
      #soft delete for blob
      blob_delete_retention_policy_days = 7
      # soft delete for container
      container_delete_retention_policy = 7
      #--------------------------------------------
    } #Default account-level immutability policy applies to all object in sa that do not possess an explicit immutability policy at the object level
    #blob_versioning = true when enable_immutability_policy= "true"
    #Allows you to set time-based retention policy on the account-level that will apply to all blob versions. 
    #Enable this feature to set a default policy at the account level. Without enabling this, 
    #you can still set a default policy at the container level or set policies for specific blob versions.
    immutability_policy_sa_acc_level = {
      enable_immutability_policy = "false"
      #manage policy, if enable_immutability false, no need to specify the following, just ignore below
      allow_protected_append_writes                = "true"
      immutability_policy_state                    = "Unlocked" #Disabled, Unlocked, Locked
      blob_immutability_policy_days_since_creation = 7
    } #--------------------------------------------
    sa_security = {
      infrastructure_encryption_enabled = "false"
      #encryption_scope
      enable_microsof_managed_encryption = "true" #if true, key_vault_key_id should be null
      key_vault_key_id                   = null   # the encryption is by microsft
    }
  }
  #===============================================================================================================================================================================================================














}
