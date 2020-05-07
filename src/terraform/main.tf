module "common" {
  source              = "./modules/common"
  resource_group_name = var.resource_group_name
  location            = var.location
  suffix              = var.suffix
}

module "aci-devops-agents" {
  source                       = "./modules/aci-devops-agents"
  resource_group_name          = module.common.resource_group_name
  location                     = var.location
  suffix                       = var.suffix
  vnet_name                    = module.common.vnet_name
  subnet_name                  = module.common.subnet_name
  agents_count                 = 2
  devops_org_name              = var.devops_org_name
  devops_pool_name             = var.devops_pool_name
  devops_personal_access_token = var.devops_personal_access_token
}
