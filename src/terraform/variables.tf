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

variable destroy_accesspolicy {

  description = "wheter to destroy the default access policy"
  default     = 0
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
