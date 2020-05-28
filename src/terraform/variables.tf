variable resource_group_name {
  description = "The RG name"
}

variable location {
  type        = string
  default     = "westeurope"
  description = "The Azure location to use for deployment"
}

variable suffix {
  type        = string
  description = "a changing suffix for distinguishing runs"
}

variable devops_agent_docker_image {
  type        = string
  description = "The image for the azure devops agents"
}

variable devops_agent_docker_tag {
  type        = string
  description = "The image tag for the azure devops agents"
}

variable devops_org_name {
  type        = string
  description = "The name of the Azure DevOps organization."
}

variable devops_pool_name {
  type        = string
  description = "The name of the Azure DevOps agent pools to use."
}

variable devops_personal_access_token {
  type        = string
  description = "The personal access token to use to connect to Azure DevOps."
}
