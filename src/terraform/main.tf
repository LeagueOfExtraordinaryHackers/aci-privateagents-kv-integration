resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "aci-devops-agents" {
  source              = "./modules/aci-devops-agents"
  resource_group_name = var.resource_group_name
  location            = var.location
  suffix              = random_string.suffix.result
}
