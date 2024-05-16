# LOCALS for AKS

locals {

}

# Cluster Resource group
resource "azurerm_resource_group" "cluster" {
  name     = "${local.base_name}-cluster"
  location = var.azure_region
}

# AKS Cluster Resources

## User Managed Identity
resource "azurerm_user_assigned_identity" "cluster" {
  resource_group_name = azurerm_resource_group.cluster.name
  location            = azurerm_resource_group.cluster.location

  name = "${local.base_name}-cluster"
}

## Add contributor role to user identity for network resource group
resource "azurerm_role_assignment" "cluster" {
  scope                = azurerm_resource_group.network.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

## AKS Cluster
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${local.base_name}-cluster"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  dns_prefix          = local.base_name

  kubernetes_version = var.aks_kubernetes_version

  network_profile {
    network_plugin    = var.aks_cni_type
    network_policy    = var.aks_cni_type
    load_balancer_sku = "standard"

  }

  default_node_pool {
    name                         = "system"
    node_count                   = var.aks_sys_node_pool.node_count
    vm_size                      = var.aks_sys_node_pool.vm_size
    availability_zones           = local.availability_zones
    tags                         = local.common_tags
    vnet_subnet_id               = azurerm_subnet.subnets["cluster"].id
    only_critical_addons_enabled = true
  }

  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.cluster.id
  }


  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [var.aks_admin_group_object_id]
      azure_rbac_enabled     = true
    }
  }

  local_account_disabled = true

  tags = local.common_tags
}

## AKS application node pool

resource "azurerm_kubernetes_cluster_node_pool" "application" {
  name                  = "application"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = var.aks_app_node_pool.vm_size
  node_count            = var.aks_app_node_pool.node_count
  availability_zones    = local.availability_zones
  vnet_subnet_id        = azurerm_subnet.subnets["cluster"].id

  tags = local.common_tags
}