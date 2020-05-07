module "common" {
  source              = "./modules/common"
  resource_group_name = var.resource_group_name
  location            = var.location
  suffix              = var.suffix
}

module "remove_access_policy" {
  source            = "./modules/remove_access_policy"
  remove_depends_on = ["${module.common.sshkey}"]
  keyvaultid        = module.common.keyvaultid
}

module "aci-devops-agents" {
  source              = "./modules/aci-devops-agents"
  resource_group_name = var.resource_group_name
  location            = var.location
  suffix              = var.suffix
}
