# Service principal object
output "service_principal_object" {
  value = azuread_service_principal.sp_sp
}


# Service principal password
output "service_principal_password" {
  value     = azuread_service_principal_password.sp_pwd.value
  sensitive = true
}