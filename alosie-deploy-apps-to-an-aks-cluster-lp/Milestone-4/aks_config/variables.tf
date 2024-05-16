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

### NETWORK VARIABLES ###

# CIDR range for Vnet

variable "vnet_cidr_range" {
  type        = string
  description = "(Required) CIDR Range to use for Virtual Network"
}

variable "vnet_subnets" {
  type        = map(string)
  description = "(Required) List of subnets to create with a name and cidr range."
}

variable "vnet_service_endpoints" {
  type = map(list(string))

  description = "(Required) Map of subnets and list of service endpoints for each subnet."
}

### AKS VARIABLES ###

# App node pool details
# Make this a map including size, VM type, and other stuff
variable "aks_app_node_pool" {
  type = object({
    node_count = number
    vm_size    = string
  })
  description = "(Required) Values to use for the creation of the application node pool."
}

# System node pool details
# Make this a map including size, VM type, and other stuff

variable "aks_sys_node_pool" {
  type = object({
    node_count = number
    vm_size    = string
  })
  description = "(Required) Values to use for the creation of the system node pool."
}

# K8s version

variable "aks_kubernetes_version" {
  type        = string
  description = "(Required)  Version of Kubernetes to deploy on AKS."
}

# CNI Type

variable "aks_cni_type" {
  type        = string
  description = "(Required) Type of container networking to use on AKS."
}

# Admin group object ID for AAD integration
variable "aks_admin_group_object_id" {
  type        = string
  description = "(Required) Object ID of group that will admin the AKS cluster"
}

### GLOBAL LOCALS ###

# Naming local value
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

locals {
  base_name          = "${var.naming_prefix}-${random_integer.suffix.result}"
  availability_zones = [1, 2, 3]
  common_tags = merge(var.common_tags, {
    Environment = terraform.workspace
  })
}