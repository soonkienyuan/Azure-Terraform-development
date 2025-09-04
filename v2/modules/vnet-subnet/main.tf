#reference : https://github.com/Azure/terraform-azurerm-vnet/tree/main
#reference: old code from "D:\Github\GitHub\azure-devops\branch-project-my-terraform\modules\networking\vnet"

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name != "" ? var.vnet_name : "vnet-${substr(md5(var.resource_group_name), 0, 8)}"
  resource_group_name = var.resource_group_name
  location            = var.vnet_location
  address_space       = var.address_space
  tags                = var.tags
}

locals {
  # Create a map of subnet names to their CIDR prefix using zipmap. (key, value)
  subnets = zipmap(var.subnet_names, var.subnet_prefixes)
}

resource "azurerm_subnet" "subnets" {
  for_each             = local.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]

  # service endpoint, otherwies empty list
  service_endpoints = lookup(var.subnet_service_endpoints, each.key, [])

  # private link policies 
  private_endpoint_network_policies             = lookup(var.subnet_private_endpoint_network_policies, each.key, "Disabled")
  private_link_service_network_policies_enabled = lookup(var.subnet_enforce_private_link_service_network_policies, each.key, false)

  #default outbound access?
  default_outbound_access_enabled = lookup(var.enabled_default_outbound_access, each.key, true)

  #  delegation if got delegation object 
  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, each.key, null) != null ? [lookup(var.subnet_delegation, each.key)] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.service_actions
      }
    }
  }
}


resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = { for key, id in var.nsg_ids : key => id }
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value
}


resource "azurerm_subnet_route_table_association" "rt_assoc" {
  for_each       = { for key, id in var.route_tables_ids : key => id }
  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = each.value
}
