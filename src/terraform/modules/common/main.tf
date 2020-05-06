resource azurerm_resource_group "rg" {
  name     = "${var.resource_group_name}-${var.suffix}"
  location = var.location
}

#network stuff
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.suffix}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.1.0/24"]

  service_endpoints = [
    "Microsoft.KeyVault"
  ]
}

#create a managed identity to access KV
resource "azurerm_user_assigned_identity" "mi" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = "kvaccess"
}

#necessary for Keyvault
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = "kv-${var.suffix}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  #only access KV from within azure and the subnet created above
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
  }
}

#let the current SP (the one TF is runnin on) set secrets
resource "azurerm_key_vault_access_policy" "current" {
  # authorize the current principal to access the keyvault secrets, keys and storage
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
  ]

  secret_permissions = [
    "get",
    "list",
    "create",
    "update"
  ]

  storage_permissions = [
  ]

  certificate_permissions = [
  ]

}

#generate and upload the SSH private key to key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "sshkey" {
  name         = "sshkey"
  value        = tls_private_key.ssh.private_key_pem
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
}

#remove permissions to current SP
/* 
resource "azurerm_key_vault_access_policy" "remove_current" {
  key_vault_id = azurerm_key_vault.keyvault.id

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

  depends_on = [
    azurerm_key_vault_access_policy.current,
  ]
} */

#add secret read access to the MI
resource "azurerm_key_vault_access_policy" "mi" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.mi.id

  key_permissions = [
  ]

  secret_permissions = [
    "get",
    "list"
  ]

  storage_permissions = [
  ]

  certificate_permissions = [
  ]

}
