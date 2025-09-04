

#azurecaf_name for vnet
resource "azurecaf_name" "vnet_name" {
  name          = var.owner
  resource_type = "azurerm_virtual_network"
  suffixes      = [var.workload, var.environment_type, var.location_short, var.number_instance]
  clean_input   = true
}
# vnet creation
resource "azurerm_virtual_network" "vnet_creation" {
  address_space       = var.address_space
  location            = var.region
  name                = azurecaf_name.vnet_name.result
  resource_group_name = var.rg_name
  bgp_community       = var.bgp_community
  dns_servers         = var.dns_servers
  tags                = var.default_tag

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []

    content {

      enable = ddos_protection_plan.value.enable
      id     = ddos_protection_plan.value.id
    }

  }

}



#subnet

resource "azurerm_subnet" "subnet_count" {
  count = var.use_for_each ? 0 : length(var.subnet_names)

  address_prefixes     = [var.subnet_prefixes[count.index]]
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_creation.name


  /*
  In order to choose a source IP address for your Private Link service, 
  an explicit disable setting privateLinkServiceNetworkPolicies is required on the subnet.

  This setting is only applicabcle for the specific private IP address 
  you chose as the source IP of the Private Link service. For other resources in the subnet, 
  access is controlled based on Network Security Groups (NSG) security rules definition.


  */

  private_endpoint_network_policies_enabled     = lookup(var.private_endpoint_network_policies_enabled, var.subnet_names[count.index], false)
  private_link_service_network_policies_enabled = lookup(var.private_link_service_network_policies_enabled, var.subnet_names[count.index], false)


  service_endpoints = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], null)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, var.subnet_names[count.index], {})

    content {
      name = delegation.key

      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }
}

resource "azurerm_subnet" "subnet_for_each" {
  for_each = var.use_for_each ? toset(var.subnet_names) : []

  address_prefixes                              = [local.subnet_names_prefixes[each.value]]
  name                                          = each.value
  resource_group_name                           = var.rg_name
  virtual_network_name                          = azurerm_virtual_network.vnet_creation.name
  private_endpoint_network_policies_enabled     = lookup(var.private_endpoint_network_policies_enabled, each.value, false)
  private_link_service_network_policies_enabled = lookup(var.private_link_service_network_policies_enabled, each.value, false)
  service_endpoints                             = lookup(var.subnet_service_endpoints, each.value, null)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, each.value, {})

    content {
      name = delegation.key

      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }
}


#nsg attach to the subnet
resource "azurerm_subnet_network_security_group_association" "vnet" {
  for_each = var.nsg_ids

  network_security_group_id = each.value
  subnet_id                 = local.azurerm_subnets_name_id_map[each.key]
}

resource "azurerm_subnet_route_table_association" "vnet" {
  for_each = var.route_tables_ids

  route_table_id = each.value
  subnet_id      = local.azurerm_subnets_name_id_map[each.key]
}

