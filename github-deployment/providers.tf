terraform {
  required_version = ">=1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.14.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>2.1.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.38.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

data "azurerm_client_config" "current" {}