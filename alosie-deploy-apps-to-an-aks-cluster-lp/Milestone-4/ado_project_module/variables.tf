variable "ado_project_name" {
  type        = string
  description = "(Required) Name of the Azure DevOps project to create"
}

variable "ado_project_description" {
  type        = string
  description = "(Required) Description of the Azure DevOps project to create"
}

variable "ado_project_visibility" {
  type        = string
  description = "(Optional) Visibility of Azure DevOps project, defaults to private"
  default     = "private"
}


variable "ado_github_pat" {
  type        = string
  description = "(Required) Personal authentication token for GitHub repo"
  sensitive   = true
}

variable "aks_service_principal_application_id" {
  type        = string
  description = "(Required) Application ID of Service Principal for Key Vault Access"
}

variable "aks_service_principal_password" {
  type        = string
  description = "(Required) Password of Service Principal for Key Vault Access"
  sensitive   = true
}

variable "aks_service_principal_tenant_id" {
  type        = string
  description = "(Required) Azure AD Tenant ID of Service Principal for Key Vault Access"
}

variable "aks_subscription_id" {
  type        = string
  description = "(Required) Subscription ID of Azure Sub with Key Vault"
}

variable "aks_subscription_name" {
  type        = string
  description = "(Required) Subscription Name of Azure Sub with Key Vault"
}

variable "ado_variables" {
  type        = list(object({
    name = string
    value = string
    sensitive = bool
  }))
  description = "(Required) List of objects create in a variable group. Keys in each object should be name (string), value (string), and secret (bool)."
}