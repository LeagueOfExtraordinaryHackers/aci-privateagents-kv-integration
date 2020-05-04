module aci-devops-agents {

  source              = "modules"
  resource_group_name = var.resource_group_name
  location            = var.location
  agent_version       = var.agent_version
  devops_access_token = var.devops_access_token
  devops_url          = var.devops_url
}
