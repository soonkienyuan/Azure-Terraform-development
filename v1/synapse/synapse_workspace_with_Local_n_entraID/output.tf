output "identity_tenant_id" {
  value = azurerm_synapse_workspace.workspace.identity[0].tenant_id

}

output "identity_principal_id" {
  value = azurerm_synapse_workspace.workspace.identity[0].principal_id

}

output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.workspace.id

}
