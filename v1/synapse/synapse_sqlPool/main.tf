resource "azurecaf_name" "sqlpool" {
  name          = "sysql"
  resource_type = "general_safe"
  suffixes      = [var.owner, var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

resource "azurerm_synapse_sql_pool" "sql_pool" {
  name = azurecaf_name.sqlpool.result

  synapse_workspace_id = var.SQLPool_synapse_workspace_id

  sku_name                  = var.SQLPool_sku_name         #DW100c, DW200c, DW300c, DW400c, DW500c, DW1000c, DW1500c, DW2000c, DW2500c, DW3000c, DW5000c, DW6000c, DW7500c, DW10000c, DW15000c, DW30000c
  create_mode               = var.SQLPool_create_mode_pool #Default, Recovery or PointInTimeRestore
  collation                 = var.SQLPool_create_mode_pool == "Default" ? var.SQLPool_collation : null
  storage_account_type      = var.redundant #GRS, LRS
  geo_backup_policy_enabled = var.SQLPool_geo_backup_policy_enabled


  data_encrypted = var.SQLPool_data_encrypted #transparent data encryption

  recovery_database_id = var.SQLPool_create_mode_pool == "Recovery" ? var.SQLPool_recovery_database_id : null


  restore {
    source_database_id = var.SQLPool_create_mode_pool == "PointInTimeRestore" ? var.SQLPool_source_database_id : null
    point_in_time      = var.SQLPool_create_mode_pool == "PointInTimeRestore" ? var.SQLPool_point_in_time : null
  }

  tags = var.default_tag
}
