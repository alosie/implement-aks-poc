# Data sources
# Get the current client config for AzureRM
data "azurerm_client_config" "current" {}

# Get the current subscription config for AzureRM
data "azurerm_subscription" "current" {}

# Create an AKS cluster using the provided aks_config module
module "aks_cluster" {
  source = "./aks_config"

  azure_region              = var.azure_region
  naming_prefix             = var.naming_prefix
  common_tags               = var.common_tags
  vnet_cidr_range           = var.aks_vnet_cidr_range
  vnet_subnets              = var.aks_vnet_subnets
  vnet_service_endpoints    = var.aks_vnet_service_endpoints
  aks_app_node_pool         = var.aks_app_node_pool
  aks_sys_node_pool         = var.aks_sys_node_pool
  aks_kubernetes_version    = var.aks_kubernetes_version
  aks_cni_type              = var.aks_cni_type
  aks_admin_group_object_id = azuread_group.cluster_admins.object_id

}

# Create a local value for the ADO variables
# The value type should be a list of objects to match the input variable in the module
locals {
  ado_variables = [
    {
      name = "terraform_version"
      value = var.ado_terraform_version
      sensitive = false
    },
    {
      name = "acr_id"
      value = module.acr.acr_id
      sensitive = false
    },
    {
      name = "acr_name"
      value = module.acr.acr_name
      sensitive = false
    },
    {
      name = "acr_login_server"
      value = module.acr.acr_login_server
      sensitive = false
    },
    {
      name = "kubernetesCluster"
      value = module.aks_cluster.aks_cluster_name
      sensitive = false
    },
    {
      name = "azureResourceGroup"
      value = module.aks_cluster.aks_resource_group_name
      sensitive = false
    },
    {
      name = "aad_sp_client_id"
      value = module.ado_service_principal.service_principal_object.application_id
      sensitive = false
    },
    {
      name = "aad_sp_client_secret"
      value = module.ado_service_principal.service_principal_password
      sensitive = true
    },
    {
      name = "aad_tenant_id"
      value = data.azurerm_client_config.current.tenant_id
      sensitive = false
    }
  ]
}

# Create an Azure DevOps project using the ado_project_module
module "ado_project" {
  source = "./ado_project_module"

  ado_project_name                     = local.base_name
  ado_project_description              = "ADO project for AKS cloud native app deployment"
  ado_github_pat                       = var.ado_github_pat
  aks_service_principal_application_id = module.ado_service_principal.service_principal_object.application_id
  aks_service_principal_password       = module.ado_service_principal.service_principal_password
  aks_service_principal_tenant_id      = data.azurerm_client_config.current.tenant_id
  aks_subscription_id                  = data.azurerm_subscription.current.subscription_id
  aks_subscription_name                = data.azurerm_subscription.current.display_name
  ado_variables                        = local.ado_variables
}

# Create an Azure Container Registry
module "acr" {
  source = "./azure_acr_module"

  azure_region          = var.azure_region
  naming_prefix         = var.naming_prefix
  common_tags           = var.common_tags
  aks_user_identity     = module.aks_cluster.aks_user_identity.principal_id
  ado_service_principal = module.ado_service_principal.service_principal_object.object_id
}