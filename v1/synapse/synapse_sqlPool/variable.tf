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
  description = "azure region"
}

variable "location_short" {
  default = "sea"
}

variable "number_instance" {
  description = "number - 001"
}

#sql pool

variable "SQLPool_synapse_workspace_id" {

}

variable "SQLPool_sku_name" {
  description = "value : DW100c, DW200c, DW300c, DW400c, DW500c, DW1000c, DW1500c, DW2000c, DW2500c, DW3000c, DW5000c, DW6000c, DW7500c, DW10000c, DW15000c, DW30000c"

}
variable "SQLPool_create_mode_pool" {
  description = "value : Default, Recovery or PointInTimeRestore"
}

variable "SQLPool_collation" {
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "redundant" {
  description = "value : GRS, LRS"
}

variable "SQLPool_geo_backup_policy_enabled" {

}

variable "SQLPool_data_encrypted" {

}

variable "SQLPool_recovery_database_id" {
  description = "required when create_mode = Recovery"
}

variable "SQLPool_source_database_id" {

}

variable "SQLPool_point_in_time" {

}
