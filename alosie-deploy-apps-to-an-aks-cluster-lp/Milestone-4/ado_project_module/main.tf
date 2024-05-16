# Local values for project settings
# Can be swapped out with input variables if desired
# Make sure to capture the service endpoint name for the Azure RM connection
locals {
  gh_service_endpoint_name  = "github-endpoint"
  aks_service_endpoint_name = "aks-cluster-endpoint"
  variable_group_name       = "ado-variables"

  variable_group_description = "Variables for Helm pipelines"

  ado_variables = concat(var.ado_variables, [{
    name = "service_name"
    value = local.aks_service_endpoint_name
    sensitive = false
  }])

}

# May not be required for all configurations
data "azuredevops_client_config" "current" {}

# Create an Azure DevOps Project with only pipelines enabled
# Using Git for version control and Agile for the template
resource "azuredevops_project" "project" {
  name               = var.ado_project_name
  description        = var.ado_project_description
  visibility         = var.ado_project_visibility
  version_control    = "Git" # This will always be Git for me
  work_item_template = "Agile"

  features = {
    # Only enable pipelines
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
  }
}

# Create a service endpoint for GitHub using a PAT for authentication
resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = local.gh_service_endpoint_name

  auth_personal {
    personal_access_token = var.ado_github_pat
  }
}

# Allow the project access to the GitHub service endpoint
resource "azuredevops_resource_authorization" "gh_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  authorized  = true
}

# Create an Azure RM service endpoint to the subscription with the
# AKS cluster and ACR registry
# Use the service principal with Contributor access to the subscription
resource "azuredevops_serviceendpoint_azurerm" "aks_cluster" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = local.aks_service_endpoint_name
  description           = "Azure Service Endpoint for AKS Cluster Access"

  credentials {
    serviceprincipalid  = var.aks_service_principal_application_id
    serviceprincipalkey = var.aks_service_principal_password
  }

  azurerm_spn_tenantid      = var.aks_service_principal_tenant_id
  azurerm_subscription_id   = var.aks_subscription_id
  azurerm_subscription_name = var.aks_subscription_name
}

# Allow the project to access the Azure RM service endpoint
resource "azuredevops_resource_authorization" "aks_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.aks_cluster.id
  authorized  = true
}

# Create a variable group with a dynamic block for the variables
resource "azuredevops_variable_group" "variablegroup" {
  project_id   = azuredevops_project.project.id
  name         = local.variable_group_name
  description  = local.variable_group_description
  allow_access = true

  dynamic "variable" {
    for_each = local.ado_variables
    content {
      name  = variable.value["name"]
      value = variable.value["value"]
      is_secret = variable.value["sensitive"]
    }
  }
}