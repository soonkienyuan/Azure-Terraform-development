
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

variable "region" {
  description = "southeastasia"
}

variable "location_short" {
  default = "sea"
}

variable "number_instance" {
  description = "number - 001"
}

variable "resource_group_name" {
}

variable "tenant_id" {

}

variable "sku_name" {
}

variable "enabled_for_deployment" {
}

variable "enabled_for_disk_encryption" {
}

variable "enabled_for_template_deployment" {
}

variable "enable_rbac_authorization" {
  default = "true"
}

variable "purge_protection_enabled" {
}

variable "soft_delete_retention_days" {
  description = "days"
}

variable "public_network_access_enabled" {
  default = false
}

#network rules
variable "bypass" {
  default = "AzureServices"
}

variable "default_action" {
  default = "Deny"
}
variable "ip_rules" {
  default = []
}

variable "virtual_network_subnet_ids" {
  default = []
}
