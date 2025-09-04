
variable "owner" {
  description = "base name : <type of deployment>-<company name>"
}

variable "workload" {

}
variable "environment_type" {
  description = "enviroment type"
  type        = string
}

variable "default_tag" {
  description = "default tag use across the rosources created"
  type        = map(any)
}

variable "location_short" {
  default = "sea"
}

variable "number_instance" {
  description = "number - 001"
}

variable "region" {
  default = "southeastasia"

}

variable "resource_group_name" {

}

#----------------------------------------------
variable "storage_data_lake_gen2_filesystem_id" {


}

#----security-------------------------------------------

variable "azuread_authentication_only" {
  description = "true or false"

}
#if azure_ad_only =false, then use both local and Microsoft Entra ID authentication 
variable "sql_administrator_login" {
  description = "login id"
}

variable "sql_administrator_login_password" {
  description = "login password"

}

variable "identity_type" {
  description = "SystemAssigned or UserAssigned"

}

variable "user_assign_identities_id" {
  description = "user assign identities id"

}

#------------------workspace encryption--------------------------------------------
variable "double_encryption_key_versionless_id" {
  description = "double encryption key versionless id"

}

variable "double_encryption_key_name" {
  description = "double encryption key name"

}
#------------------networking--------------------------------------------
variable "data_exfiltration_protection_enabled" {
  description = "true or false"

}

variable "public_network_access_enabled" {
  description = "true or false"

}

variable "managed_virtual_network_enabled" {
  description = "true or false"

}

variable "workspace_firewall_rule_name" {
  description = "workspace firewall rule name"
}

variable "start_ip_address" {

}

variable "end_ip_address" {

}

#store password in keyvault

variable "keyvault_id_to_store" {

}
