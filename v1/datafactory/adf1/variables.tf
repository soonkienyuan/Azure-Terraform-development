
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

#basic

variable "resource_group_name" {

}

variable "region" {
  description = "azure region"
}

#netwoking
variable "managed_virtual_network_enabled" {
  description = "value true or false"
}

variable "public_network_enabled" {
  description = "value true or false"
}

variable "type_identity" {
  description = "SystemAssigned, UserAssigned, or both SystemAssigned, UserAssigned"

}

variable "user_assign_identities_id" {
  description = "user assign identity id"
  type        = list(string)

}

variable "double_encryption_customer_managed_key_id" {
  description = "Specifies the ID of the user assigned identity associated with the Customer Managed Key. Must be supplied if customer_managed_key_id is set."

}

variable "purview_id" {
  description = "purview id associated with the data factory"
  default     = ""

}

variable "customer_managed_key_identity_id" {

}
