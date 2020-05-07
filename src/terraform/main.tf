module "common" {
  source              = "./modules/common"
  resource_group_name = var.resource_group_name
  location            = var.location
  suffix              = var.suffix
}

module "aci-devops-agents" {
  source              = "./modules/aci-devops-agents"
  resource_group_name = var.resource_group_name
  location            = var.location
  suffix              = var.suffix
}
