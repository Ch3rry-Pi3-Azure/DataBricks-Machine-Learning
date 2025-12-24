terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "random_pet" "workspace" {
  length    = 1
  separator = "-"
}

resource "azurerm_databricks_workspace" "main" {
  name                        = var.workspace_name != null ? var.workspace_name : "${var.workspace_name_prefix}-${random_pet.workspace.id}"
  resource_group_name         = data.azurerm_resource_group.main.name
  location                    = coalesce(var.location, data.azurerm_resource_group.main.location)
  sku                         = var.sku
  managed_resource_group_name = var.managed_resource_group_name != null ? var.managed_resource_group_name : "${var.workspace_name_prefix}-${random_pet.workspace.id}_managed"
  public_network_access_enabled = var.public_network_access_enabled
  tags                        = var.tags
}
