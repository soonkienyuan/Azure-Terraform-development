terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">4.0.1"
    }
    # azapi = {
    #   source  = "azure/azapi"
    #   version = "~>1.5"
    # }
  }
}
