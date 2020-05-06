resource azurerm_resource_group "rg" {
  name     = "${var.resource_group_name}-${var.suffix}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_user_assigned_identity" "mi" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"

  name = "kvaccess"
}

#necessary for Keyvault
data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "key_vault" {
  name                        = "kv-${var.suffix}"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  location                    = "${azurerm_resource_group.rg.location}"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = ["${azurerm_virtual_network.vnet.subnet.id}"]
  }

  # authorize the current principal to access the keyvault secrets, keys and storage
  access_policy {
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
}
