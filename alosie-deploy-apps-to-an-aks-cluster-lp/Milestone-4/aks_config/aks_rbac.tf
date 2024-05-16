# All users need to be members of the Azure Kubernetes Service Cluster User Role
# to be able to login, regardless of what AKS permissions they have
resource "azurerm_role_assignment" "cluster_user" {
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  scope                = azurerm_kubernetes_cluster.cluster.id
  principal_id         = var.aks_admin_group_object_id
}

# Get the subscription we're using and grant Cluster Admins for the 
# whole subscription

data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "cluster_admins" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  # Note the scope should be the subscription, not just the cluster
  scope        = data.azurerm_subscription.current.id
  principal_id = var.aks_admin_group_object_id
}