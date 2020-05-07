data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_profile" "network_profile" {
  count               = var.agents_count
  name                = "aciprofile${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  container_network_interface {
    name = "acinic${count.index}"

    ip_configuration {
      name      = "aciipconfig${count.index}"
      subnet_id = data.azurerm_subnet.subnet.id
    }
  }
}

resource "azurerm_container_group" "aci-example" {
  count               = var.agents_count
  name                = "aci-devops-agents-${var.suffix}-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "private"
  os_type             = "linux"
  network_profile_id  = azurerm_network_profile.network_profile[count.index].id

  container {
    name   = "azdoagents"
    image  = "${var.image}:${var.tag}"
    cpu    = "1"
    memory = "7"
    # this field seems to be mandatory (error happens if not there). See https://github.com/terraform-providers/terraform-provider-azurerm/issues/1697#issuecomment-608669422
    ports {
      port     = 9998
      protocol = "UDP"
    }
    environment_variables = {
      VSTS_ACCOUNT = var.devops_org_name
      VSTS_POOL = var.devops_pool_name
      VSTS_TOKEN = var.devops_personal_access_token
      VSTS_AGENT= "aci-devops-agents-${var.suffix}-${count.index}"
    }
  }
}