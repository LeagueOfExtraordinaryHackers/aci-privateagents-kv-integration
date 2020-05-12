Terraform module to add a KV-managed access key to an existing storage acccount.

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

https://www.terraform.io/docs/providers/azurerm/r/storage_account_customer_managed_key.html
https://github.com/terraform-providers/terraform-provider-azurerm/issues/6111
https://docs.microsoft.com/en-us/azure/key-vault/secrets/overview-storage-keys