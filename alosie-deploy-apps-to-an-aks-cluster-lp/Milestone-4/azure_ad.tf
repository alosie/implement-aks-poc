# Get the current client Azure AD config
data "azuread_client_config" "current" {}

# Use the Azure AD SP module
module "ado_service_principal" {
  source = "./service_principal_module"

  app_display_name = local.ado_service_principal_name

}

# Azure AD Groups
# Create an Azure AD group to use as a cluster admin on the AKS cluster
# The service principal should be a member
resource "azuread_group" "cluster_admins" {
  display_name     = "${local.base_name}-cluster-admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    module.ado_service_principal.service_principal_object.object_id
  ]
}