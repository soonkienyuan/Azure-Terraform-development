locals {
  # Only use the endpoints from variable if environment is "prod"
  endpoints = var.environment == "prd" ? var.endpoints : {}
}

resource "azurerm_private_endpoint" "pe" {
  for_each = local.endpoints

  resource_group_name = var.resource_group_name
  name                = "pe-${each.value.name_suffix}-${basename(var.private_connection_resource_id)}"
  location            = var.location
  subnet_id           = var.subnet_id
  tags = {
    environment   = var.environment
    workload      = var.workload
    location      = var.location_abb
    project       = var.project
    parent        = basename(var.private_connection_resource_id)
    subnet        = basename(var.subnet_id)
    endpoint_type = each.value.name_suffix
  }

  private_service_connection {
    name                           = "psc-${each.value.name_suffix}-${basename(var.private_connection_resource_id)}"
    is_manual_connection           = false
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = [each.value.pcs_subresource_name]
  }

  # ip_configuration {
  #   name               = "ipconfig-${each.value.name_suffix}-${basename(var.private_connection_resource_id)}"
  #   private_ip_address = each.value.ip_address
  #   subresource_name   = each.value.subresource_name
  #   member_name        = try(each.value.member_name, null)
  # }

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations
    content {
      name               = "ipconfig-${coalesce(ip_configuration.value.member_name, each.value.pcs_subresource_name)}-${basename(var.private_connection_resource_id)}"
      private_ip_address = ip_configuration.value.ip_address
      subresource_name   = ip_configuration.value.subresource_name
      member_name        = lookup(ip_configuration.value, "member_name", null)
    }
  }
}
