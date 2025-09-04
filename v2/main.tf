#vnet


#nsg


#pe

variable "st_pltf_pe" {
  type = map(object({
    name_suffix      = string           # Used to differentiate endpoint types (e.g., "dfs", "blob", "table")
    ip_address       = string           # The private IP address for this endpoint
    subresource_name = string           # The subresource name used in the private connection and ip configuration
    member_name      = optional(string) # The member name used in the ip configuration
  }))
  default = {}
}

module "pe_st_pltf" {
  source = "./modules/pe" # Adjust the path as necessary

  project      = var.project
  workload     = var.pltf_workload
  location_abb = var.location_abb
  environment  = var.environment
  location     = var.location

  resource_group_name = azurerm_resource_group.pltf.name

  endpoints                      = var.st_pltf_pe
  subnet_id                      = data.azurerm_subnet.subnets_vnet02[var.snet_name_vnet02[3]].id
  private_connection_resource_id = azurerm_storage_account.adls_pltf.id
}
