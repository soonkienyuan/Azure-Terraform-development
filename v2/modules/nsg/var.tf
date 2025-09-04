variable "project_name" {
}

variable "resource_group_name" {
}

variable "nsg_name_configs" {
  description = "Map of NSG name configurations." #the key must be unique
  type = map(object({
    workload     = string
    environment  = string
    location     = string
    instance     = string
    location_abb = string
  }))
}
