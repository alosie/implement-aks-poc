# Create the resource group for the container registry
resource "azurerm_resource_group" "acr" {
  name     = local.base_name
  location = var.azure_region
}

# Create the container registry
resource "azurerm_container_registry" "acr" {
  name                = local.base_name
  resource_group_name = azurerm_resource_group.acr.name
  location            = azurerm_resource_group.acr.location
  sku                 = "Standard"

  tags = local.common_tags
}

# Grant AcrPull to AKS cluster
resource "azurerm_role_assignment" "aks" {
  principal_id                     = var.aks_user_identity
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# Grant Contributor role role to ADO service principal
resource "azurerm_role_assignment" "ado" {
  principal_id                     = var.ado_service_principal
  role_definition_name             = "Contributor"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
