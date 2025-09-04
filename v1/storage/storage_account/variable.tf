
variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
  default     = null

}

variable "owner" {
  description = "base name : <type of deployment>-<company name>"
  #default     = "nase"
}

variable "workload" {
  type = string

}

variable "environment_type" {
  description = "enviroment type"
  type        = string

}

variable "location" {
  description = "azure region"
  default     = "Southeast Asia"
}

variable "location_short" {
  default = "sea"

}

variable "number_instance" {
  description = "number - 001"

}


# name and basic

variable "resource_group_name" {
  description = "resource group for storage"

}

variable "region" {
  type = string

}
variable "account_tier" {
  description = "For BlockBlobStorage and FileStorage accounts only Premium is valid."
  #default     = "Standard"

}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
  #default     = "StorageV2"

}

variable "account_replication_type" {
  #default = "LRS"

}


# advanced

variable "enable_https_traffic_only" {
  #default = "true"
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items (blob/containers) within this Account to opt into being public"
  #default = "true"
}


#To protect an Azure Storage account with Microsoft Entra Conditional Access policies, 
#you must disallow Shared Key authorization for the storage account.
variable "shared_access_key_enabled" {
  description = <<EOF
  Indicates whether the storage account permits requests to 
  be authorized with the account access key via Shared Key. 
  If false, then all requests, including shared access signatures, 
  must be authorized with Azure Active Directory (Azure AD). 
  EOF

}
variable "default_to_oauth_authentication" {
  description = <<EOF
  Default to Azure Active Directory authorization in 
  the Azure portal when accessing the Storage Account. 
  The default value is false
  EOF 
}

variable "allowed_copy_scope" {
  description = <<EOF
 Restrict copy to and from Storage Accounts within an AAD tenant 
 or with Private Links to the same VNet. 
 Possible values are AAD and PrivateLink
  EOF  
}


variable "access_tier" {
  description = "Valid options are Hot and Cool, defaults to Hot."
  #default     = "Hot"

}



variable "enable_hns" {
  default = "true"
}
variable "enable_sftp" {
  description = "enable_hns must be set to true for this to work."
  type        = string
  default     = "false"

}

variable "nfsv3_enabled" {
  description = "Network File System (NFS) 3.0 protocol"
  default     = "false"

}

variable "blob_cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled?."

}

variable "enable_large_file_share" {
  description = "Enable Large File Share."
  default     = "false"
}

#network

variable "public_network_access_enabled" {
  #default = "false"
}

variable "routing_choice" {
  description = " Possible values are InternetRouting and MicrosoftRouting. Defaults to MicrosoftRouting."
  default     = "MicrosoftRouting"
}


variable "pv_endpointID" {
  description = "The ID of the Private Endpoint to associate with the Storage Account."
  type        = string
  default     = ""

}


#data proctection retention policy


variable "enable_restore_policy" {
  description = "versioning_enabled and change_feed_enabled set to true"
  type        = bool

}
variable "container_restore_policy_days" {
  description = <<EOF
Specifies the number of days that the blob can be restored, between 1 and 365 days. 
This must be less than the days specified for delete_retention_policy.

This must be used together with delete_retention_policy set, 
versioning_enabled and change_feed_enabled set to true.

also known as point-in-time restore is enabled, then versioning, change feed, 
and blob soft delete must also be enabled
  EOF

  #default = 7

}
variable "blob_delete_retention_policy_days" {
}
variable "blob_versioning_enabled" {
  type = bool
}
variable "change_feed_enabled" {
  type = bool
}
variable "change_feed_retention_in_days" {
  type = number
}
variable "last_access_time_enabled" {
  type = bool
}
variable "container_delete_retention_policy_days" {
  type = string
}

# account level Immutability policies

variable "enable_immutability_policy" {
  type = bool

}

variable "allow_protected_append_writes" {

}

variable "immutability_policy_state" {
  description = "Disabled, Unlocked, Locked"

}

variable "blob_immutability_policy_days_since_creation" {

}

#security
variable "infrastructure_encryption_enabled" {
  description = "Is infrastructure encryption enabled"

}

variable "queue_encryption_key_type" {

}

variable "table_encryption_key_type" {

}

variable "key_vault_key_id" {
  description = "The Key Vault Key ID used to encrypt the data at rest. Required when infrastructure_encryption_enabled is set to true."
  type        = string
  default     = null
}

variable "user_assign_identities_id_to_encrypt" {

}

#data lake storage gen 2
variable "default_tag" {
  description = "default tag use across the rosources created"
  type        = map(any)
  default = {
    project     = "iac-nase"
    enviroment  = "test"
    deployed_by = "soon-terraform"
  }

}


#identities
variable "identity_type" {
  description = "The type of identity used for the storage account. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None. Defaults to None."
  type        = string

}

variable "user_assign_identities_id" {
  description = "A list of User Assigned Identity ids to be assigned to the storage account. Required when identity_type is set to UserAssigned."
}
