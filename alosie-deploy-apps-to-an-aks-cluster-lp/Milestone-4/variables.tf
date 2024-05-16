# Azure region for deployment
variable "azure_region" {
  type        = string
  description = "(Optional) Azure region for deployment, East US by default.)"
  default     = "eastus"
}

# Naming prefix
variable "naming_prefix" {
  type        = string
  description = "(Optional) Naming prefix for resources, eco by default"
  default     = "eco"
}

# Tags for resources

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of tags to apply to all resources, empty map by default"
  default     = {}
}

### AKS NETWORK VARIABLES ###

# CIDR range for Vnet

variable "aks_vnet_cidr_range" {
  type        = string
  description = "(Required) CIDR Range to use for Virtual Network"
}

variable "aks_vnet_subnets" {
  type        = map(string)
  description = "(Required) List of subnets to create with a name and cidr range."
}

variable "aks_vnet_service_endpoints" {
  type = map(list(string))

  description = "(Required) Map of subnets and list of service endpoints for each subnet."
}

### AKS CLUSTER VARIABLES ###

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

### ADO Variables

variable "terraform_state_key" {
  type        = string
  description = "(Optional) String to use for the state key naming in Terraform remote state, terraform.tfstate by default"
  default     = "terraform.tfstate"
}

variable "deployment_subscription_id" {
  type        = string
  description = "(Optional) Subscription ID to grant Contributor rights on for deployment service principal. Set to current client subscription ID by default."
  default     = null
}

variable "ado_github_pat" {
  type        = string
  description = "(Required) Personal authentication token for GitHub repo"
  sensitive   = true
}

variable "ado_terraform_version" {
  type        = string
  description = "(Optional) Version of Terraform to use in pipelines, defaults to 1.0.10"
  default     = "1.1.5"
}

### GLOBAL LOCALS ###

# Random integer for unique naming
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

# Locals used for naming and common tags
locals {
  base_name                  = "${var.naming_prefix}-${random_integer.suffix.result}"
  ado_service_principal_name = "${local.base_name}-ado"
  common_tags = merge(var.common_tags, {
    Environment = terraform.workspace
  })
}