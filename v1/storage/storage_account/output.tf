output "id_storage_account" {
  value = azurerm_storage_account.azure_storage_account.id

}

output "identity_tenant_id" {
  value = azurerm_storage_account.azure_storage_account.identity[0].tenant_id

}

output "identity_principal_id" {
  value = azurerm_storage_account.azure_storage_account.identity[0].principal_id

}
