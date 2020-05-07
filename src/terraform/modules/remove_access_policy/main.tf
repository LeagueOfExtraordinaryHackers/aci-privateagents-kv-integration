#remove permissions to current SP

variable "remove_depends_on" {
  type    = any
  default = null
}

variable keyvaultid {
  description = "the KV id"
}

resource "azurerm_key_vault_access_policy" "remove_current" {

  depends_on = [var.remove_depends_on]

  key_vault_id = var.keyvaultid

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
