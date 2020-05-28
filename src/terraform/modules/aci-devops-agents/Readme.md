# A module to deploy the infrastructure for ACI-based Azure DevOps agents

Usage:

```hcl
module "aci-devops-agents" {
  source                       = "."
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
```

Variables:

- resource_group_name: the name of the resource group where to create the agents
- location: the Azure location where to deploy
- suffix: a suffix added to all deployed resources for unicity
- vnet_name: the name of the virtual network in which deploy the agents
- subnet_name: the name of the subnet in which deploy the agents
- agent_counts: the number of desired agents
- devops_org_name: the name of the Azure DevOps organization in which the agents will be registered
- devops_pool_name: the name of the Azure DevOps agent pool to use
- devops_personal_access_token: a personal access token used for Azure DevOps connection
