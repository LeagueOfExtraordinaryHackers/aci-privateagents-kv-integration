variable resource_group_name {
  description = "The RG name"
}

variable location {
  type        = string
  default     = "westeurope"
  description = "The Azure location to use for deployment"
}

variable agent_version {
  type        = string
  default     = "2.163.1"
  description = "The version of the Azure DevOps agent to install"
}

variable devops_access_token {
  type        = string
  description = "The personal access token to use to connect to Azure DevOps"
}

variable devops_url {
  type        = string
  default     = "https://dev.azure.com/VW-DEVOPS"
  description = "The URL of the Azure DevOps organization for the agents (i.e https://dev.azure.com/DEVOPS_ORGANIZATION_NAME)"
}

variable agent_count {
  type        = string
  default     = "2"
  description = "The number of agents to create in the scale-set"
}