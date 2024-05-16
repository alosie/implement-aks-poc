# Network Resource group

resource "azurerm_resource_group" "network" {
  name     = "${local.base_name}-network"
  location = var.azure_region
}

# Virtual network Resources

## Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = local.base_name
  resource_group_name = azurerm_resource_group.network.name
  address_space       = [var.vnet_cidr_range]
  location            = azurerm_resource_group.network.location

  tags = local.common_tags
}

## Subnets for cluster, app gateway, and internal load balancer
resource "azurerm_subnet" "subnets" {
  for_each             = var.vnet_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}

## Network security groups for internal lb subnet
resource "azurerm_network_security_group" "nsg" {
  name                = "${local.base_name}-internal"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  tags = local.common_tags
}

## Network security group associations for internal lb subnet
resource "azurerm_subnet_network_security_group_association" "nsgs" {
  subnet_id                 = azurerm_subnet.subnets["internal-load-balancer"].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
