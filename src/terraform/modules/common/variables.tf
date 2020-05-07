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
  type        = string
  description = "wheter to destroy the default access policy"
}
