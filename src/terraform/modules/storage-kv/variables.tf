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

variable "keyvault_name" {
  type = string
}

variable "keyvault_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "azurerm_storage_account_identity_principal_id" {
  type = string
}
