variable "subscription_id" {
    type = string
    description = "Azure Subscription ID"
    sensitive = true
}

variable "base_name" {
    type = string
    description = "Name of the resource"
    default = "westus"
}

variable "base_name_app" {
    type = string
    description = "Name of the Azure AD application"
    default = "app-wus-aharo"
}

variable "base_name_storage" {
    type = string
    description = "Name of the storage account"
    default = "stgwusaharo"
  
}

variable "location" {
    type = string
    description = "Name of the location use for the resource"
    default = "West US"
}

variable "base_name_network_security_group" {
    type = string
    description = "Name of the network security group"
    default = "secgrp-wus-aharo"
}

variable "base_name_vnet" {
    type = string
    description = "Name of the virtual network"
    default = "vnet-wus-aharo"
}

variable "tags" {
    type = map(string)
    description = "Tags to assign to the resource"
    default = {
      environment = "dev"
    }
}

variable "name_identity" {
    type = string
    description = "Name of the user assigned identity"
    default = "aharo-identity"
  
}

variable "identity_rg_name" {
    type = string
    description = "Name of the resource group"
    default = "rg-identity-aharo"
  
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group"
    default = "wus-aharo"
  
}

variable role_definition_name {
    type = string
    description = "Name of the role definition"
    default = "Owner"
}

variable "principal_type" {
    type = string
    description = "Type of principal"
    default = "ServicePrincipal"
}

variable "owner_role_name" {
  description = "The name of the role definition to assign."
  type        = string
  default = "Owner"
}

variable "role_name" {
  description = "The name of the role to assign."
  type        = string
  default = "ServicePrincipal"
}

variable "github_organization_target" {
  description = "The name of the GitHub organization."
  type        = string
  default = "hvaandres"
}

variable "github_repository" {
  description = "The name of the GitHub repository."
  type        = string
  default = "Azure-Terraform"
}

variable "environment" {
  description = "The environment for the federated identity credential."
  type        = string
  default = "dev"
}

variable "base_name_container" {
  description = "The base name of the storage account container."
  type        = string
  default = "wusstate"
  
}