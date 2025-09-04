variable "resource_group_name" {
  type = string
}

variable "vnet_location" {
  type = string
}

variable "vnet_name" {
  type    = string
  default = ""
}

variable "address_space" {
  type = list(string)
}

variable "subnet_prefixes" {
  type = list(string)
}

variable "subnet_names" {
  type = list(string)
}

variable "nsg_ids" {
  description = " subnet  to the NSG ID ."
  type        = map(string)
  default     = {}
}

variable "subnet_service_endpoints" {
  description = "subnet to a list of service endpoints."
  type        = map(list(string))
  default     = {}
}


#For example: { subnet2 = { name = \"delegation-name\", service_name = \"Microsoft.Sql/managedInstances\", service_actions = [ \"Microsoft.Network/virtualNetworks/subnets/join/action\", ... ] } }"
variable "subnet_delegation" {
  description = "subnet to an object with delegation settings."
  type = map(object({
    name            = string
    service_name    = string
    service_actions = list(any)
  }))
  default = {}
}

variable "route_tables_ids" {
  description = "subnet to route table IDs."
  type        = map(string)
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet_private_endpoint_network_policies" {
  description = "subnet to a values, Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled. Defaults to Disabled.."
  type        = map(any)
  default     = {}
}

variable "subnet_enforce_private_link_service_network_policies" {
  description = " subnet name to values, true or false. Defaults to false."
  type        = map(any)
  default     = {}
}

variable "enabled_default_outbound_access" {
  type    = map(any)
  default = {}
}


# This variable is provided so the module caller can decide if they want to use for_each at the module level.
variable "use_for_each" {
  description = "Not used inside the module but can be used by the caller when instantiating the module multiple times if you want"
  type        = bool
  default     = false
}


