# ACR ID
output "acr_id" {
  value = azurerm_container_registry.acr.id
}

# Login server address
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

# ACR name
output "acr_name" {
  value = azurerm_container_registry.acr.name
}