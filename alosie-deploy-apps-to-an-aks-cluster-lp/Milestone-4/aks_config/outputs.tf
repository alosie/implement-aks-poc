# Cluster FQDN

output "aks_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.cluster.fqdn
}

# Cluster Name
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.cluster.name
}

# Cluster Resource Group
output "aks_resource_group_name" {
  value = azurerm_resource_group.cluster.name
}

# Cluster MC Resource Group
output "aks_mc_resource_group" {
  value = azurerm_kubernetes_cluster.cluster.node_resource_group
}

# Kube config for deployments
output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config
}

output "aks_user_identity" {
  value = azurerm_user_assigned_identity.cluster
}