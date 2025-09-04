variable "rg_name" {
  type = string

}
variable "owner" {
  description = "clinet name"
  default     = "nase"
}

variable "environment_type" {
}

variable "workload" {
  type = string
}

variable "number_instance" {
  type = string

}

variable "region" {
  default = "southeastasia"

}

variable "location_short" {

}

variable "address_space" {
  description = "address space for vnet"
  type        = list(any)
  #default     = ["10.105.0.0/16"]


}

variable "default_tag" {
  description = "default tag use across the rosources created"
  type        = map(any)
  default = {
    project     = "iac-nase"
    enviroment  = "test"
    deployed_by = "soon-terraform"
  }
}

variable "bgp_community" {
  type        = string
  default     = null
  description = "(Optional) The BGP community attribute in format `<as-number>:<community-value>`."
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  default     = null
  description = "The set of DDoS protection plan configuration"
}

# If no values specified, this defaults to Azure DNS
variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "The DNS servers to be used with vNet."
}

variable "subnet_names" {
  type        = list(string)
  description = "A list of public subnets inside the vNet."
}

variable "use_for_each" {
  type        = bool
  description = "Use `for_each` instead of `count` to create multiple resource instances."
  nullable    = false
}

variable "subnet_prefixes" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "The address prefix to use for the subnet."
}

variable "subnet_service_endpoints" {
  type        = map(any)
  default     = {}
  description = "A map of subnet name to service endpoints to add to the subnet."
}

variable "subnet_enforce_private_link_service_network_policies" {
  type        = map(bool)
  default     = {}
  description = "A map of subnet name to enable/disable private link service network policies on the subnet."
}
variable "private_link_service_network_policies_enabled" {
  type        = map(bool)
  default     = {}
  description = "A map of subnet name to enable/disable private link services network policies on the subnet."
}

variable "private_endpoint_network_policies_enabled" {
  type        = map(bool)
  default     = {}
  description = "A map of subnet name to enable/disable private endpoint  network policies on the subnet."
}

variable "subnet_delegation" {
  type        = map(map(any))
  default     = {}
  description = "A map of subnet name to delegation block on the subnet"
}

variable "nsg_ids" {
  type = map(string)
  default = {
  }
  description = "A map of subnet name to Network Security Group IDs"
}

variable "route_tables_ids" {
  type        = map(string)
  default     = {}
  description = "A map of subnet name to Route table ids"
}


