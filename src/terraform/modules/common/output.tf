output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "keyvaultid" {
  value = azurerm_key_vault.keyvault.id
}

output "accesspolicyid" {
  value = azurerm_key_vault_access_policy.current.id
}


