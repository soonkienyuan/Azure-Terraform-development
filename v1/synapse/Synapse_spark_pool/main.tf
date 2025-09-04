resource "azurecaf_name" "sqlpool" {
  name          = var.owner
  resource_type = "sysp"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}

