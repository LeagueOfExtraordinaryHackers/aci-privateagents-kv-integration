variable resource_group_name {
  description = "The RG name."
}

variable location {
  type        = string
  default     = "westeurope"
  description = "The Azure location to use for deployment."
}

variable suffix {
  type        = string
  description = "A changing suffix for distinguishing runs."
}

variable vnet_name {
  type        = string
  description = "The name of the vnet in which the containerized agents will be included."
}

variable subnet_name {
  type        = string
  description = "The name of the subnet of the vnet in which the containerized agents will be included."
}

variable agents_count {
  type        = number
  description = "The number of DevOps agents to deploy."
}

variable devops_org_name {
  type = string
  description = "The name of the Azure DevOps organization."
}

variable devops_pool_name {
  type = string
  description = "The name of the Azure DevOps agent pools to use."
}

variable devops_personal_access_token {
  type = string
  description = "The personal access token to use to connect to Azure DevOps."
}