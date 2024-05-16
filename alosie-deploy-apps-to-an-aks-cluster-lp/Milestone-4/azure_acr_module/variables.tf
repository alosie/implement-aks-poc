### AZURE VARIABLES ###

# Azure region for deployment

variable "azure_region" {
  type        = string
  description = "(Required) Azure region to use for deployment."
}

# Naming prefix
variable "naming_prefix" {
  type        = string
  description = "(Required) Naming prefix for all resources. Keep to 6 characters"
}

# Tags for resources
variable "common_tags" {
  type        = map(string)
  description = "(Required) Map of tags to apply to all resources"
}

# AKS user identity object id
variable "aks_user_identity" {
  description = "(Required) The object ID of the AKS Cluster identity."
  type        = string
}

# ADO service principal object id
variable "ado_service_principal" {
  description = "(Required) The object ID of the ADO service principal object."
  type        = string
}

### GLOBAL LOCALS ###

# Naming local value
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

locals {
  base_name = "${var.naming_prefix}${random_integer.suffix.result}"
  common_tags = merge(var.common_tags, {
    Environment = terraform.workspace
  })
}