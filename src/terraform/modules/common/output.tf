output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "keyvaultid" {
  value = azurerm_key_vault.keyvault.id
}

output "accesspolicyid" {
  value = azurerm_key_vault_access_policy.current.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}


