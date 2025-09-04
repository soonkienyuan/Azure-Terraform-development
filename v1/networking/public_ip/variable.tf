
variable "resource_group_name" {
  type = string

}

variable "workload" {
  type        = string
  description = "service name / app name"


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



# public ip

variable "allocation_method" {
  default = "Static"

}

variable "pip_sku" {
  default = "Standard"

}

variable "private_dns_zone_group_name" {
  default = "nase"

}
