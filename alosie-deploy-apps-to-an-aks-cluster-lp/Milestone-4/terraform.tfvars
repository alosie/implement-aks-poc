# AZURE VALUES
azure_region = "eastus"

naming_prefix = "ecoaks"

common_tags = {
  Business-Unit = "WebDev-NA"
  Project-ID    = "AKS-101"
  Cost-Center   = "AppDev-NA"
}

# VNET VALUES
aks_vnet_cidr_range = "10.42.0.0/16"

aks_vnet_subnets = {
  cluster                = "10.42.0.0/22"
  internal-load-balancer = "10.42.4.0/27"
}

aks_vnet_service_endpoints = {
  cluster = ["Microsoft.KeyVault"]
}

# AKS VALUES
aks_app_node_pool = {
  node_count = 1
  vm_size    = "Standard_D2s_v4"
}

aks_sys_node_pool = {
  node_count = 1
  vm_size    = "Standard_D2s_v4"
}

# Use az aks get-versions --location eastus to get current versions
aks_kubernetes_version = "1.21.9"

aks_cni_type = "azure"