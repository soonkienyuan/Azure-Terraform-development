variable "environment" {
}

# variable "endpoints" {
#   type = map(object({
#     name_suffix      = string           # Used to differentiate endpoint types (e.g., "dfs", "blob", "table")
#     ip_address       = string           # The private IP address for this endpoint
#     subresource_name = string           # The subresource name used in the private connection and ip configuration
#     member_name      = optional(string) # The member name used in the ip configuration
#   }))
#   default = {}
# }

variable "project" {
}

variable "workload" {
}

variable "location_abb" {

}

variable "resource_group_name" {
}

variable "location" {
}

variable "subnet_id" {
}


variable "private_connection_resource_id" {
}


variable "endpoints" {
  type = map(object({
    name_suffix          = string
    pcs_subresource_name = string
    ip_configurations = list(object({
      ip_address       = string
      subresource_name = string
      member_name      = optional(string)
    }))
  }))
  default = {}
}
