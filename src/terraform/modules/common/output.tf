output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "keyvaultid" {
  value = azurerm_key_vault.keyvault.id
}
