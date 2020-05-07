variable key_vault_id {
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = var.key_vault_id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
  ]

  secret_permissions = [
  ]

  storage_permissions = [
  ]

  certificate_permissions = [
  ]

}

