
# naming and rg variables
variable "Clientname" {

}

variable "resource_group_name" {
  type = string
}

variable "region" {
  description = "azure region"
  default     = "southeastasia"
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

variable "workload" {
  type        = string
  description = "service name / app name"
}

#public ip
variable "public_ip_address_id" {
  description = "public ip for bastion host"

}



#bastion

variable "bastion_subnet_id" {
  description = "the subnet must be named AzureBastionSubnet, we call the module output.tf to get subnet id like this :module.vnet.subnet_ids[AzureBastionSubnet]"
}

variable "bastion_sku" {

}


#optional

variable "copy_paste_enabled" {
  default = "true"

}
variable "file_copy_enabled" {
  default = "false"

}

variable "ip_connect_enabled" {
  description = "connect using private ip"
  default     = "false"

}

variable "tunneling_enabled" {
  description = "native client"
  default     = "false"

}

variable "shareable_link_enabled" {
  default = "false"

}

variable "scale_units" {

}



