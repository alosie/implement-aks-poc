# We will need the azurerm and azuread providers for this configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

# AzureRM provider block with feature block
provider "azurerm" {
  features {}
}