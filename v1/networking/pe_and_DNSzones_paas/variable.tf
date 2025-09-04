variable "region" {
  description = "azure region"
  #default     = "southeastasia"
}

variable "owner" {
  type = string
}

variable "workload" {
  type = string
}

variable "environment_type" {
  description = "enviroment type"
  type        = string
}

variable "location_short" {
}

variable "number_instance" {
  description = "number - 001"

}



#private endpoint

variable "Private_endpoint_resource_group_name" {

}

variable "subnet_id" {
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. "


}


variable "default_tags" {
  description = "default tag use across the rosources created"
  type        = map(any)
  # default = {
  #   project     = "iac-nase"
  #   enviroment  = "test"
  #   deployed_by = "soon-terraform"
  # }
}

# private_services_connection


# If you are trying to connect the Private Endpoint to a remote resource 
# without having the correct RBAC permissions on the remote resource set this value to true
variable "is_manual_connection" {
  description = " Does the Private Endpoint require Manual Approval from the remote resource owner?"
}
#example resource.account.id
variable "private_connection_resource_id" {
  description = "The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to"
}

variable "subresource_names" {
  description = " list of subresource names which the Private Endpoint is able to connect to"
  type        = list(any)
  # example : ["blob"]
}

variable "request_message" {
  type        = string
  description = "A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource"
  default     = "please approve......"
}


#specify private dns zone group id

variable "private_dns_zone_id" {
  type = list(any)

}
