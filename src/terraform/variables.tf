variable resource_group_name {
  description = "The RG name"
}

variable location {
  type        = string
  default     = "westeurope"
  description = "The Azure location to use for deployment"
}

variable backend_storage_account_name {
  type        = string
  default     = "tfstate"
  description = "The storage account name for the terraform state, will be appended with suffix"
}