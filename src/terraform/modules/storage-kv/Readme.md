Call as:

```
module "storage-kv" {
  source              = "./modules/common"
  resource_group_name = var.resource_group_name
  location            = var.location
  suffix              = var.suffix
  keyvault            = module.common.keyvault_name
}

```


Refs:

https://github.com/terraform-providers/terraform-provider-azurerm/issues/6111
