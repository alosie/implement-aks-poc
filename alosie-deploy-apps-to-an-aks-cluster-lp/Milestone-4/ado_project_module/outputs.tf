# Supply the Organization URL just in case
output "ado_org_url" {
  value = data.azuredevops_client_config.current.organization_url
}