terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.4.0"
    }
  }
backend "azurerm" {
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    subscription_id   = ""
    tenant_id         = ""
    access_key=""
  }
}

provider "azurerm" {
  features {
    resource_group { 
      prevent_deletion_if_contains_resources = false
    }
  }


  subscription_id   = ""
  tenant_id         = ""
  client_id         = ""
  client_secret     = ""
}

resource "azurerm_resource_group" "rgmain" {
  name     = ""
  location = ""
}

resource "azurerm_virtual_network" "main" {
  name                = "Epam-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rgmain.location
  resource_group_name = azurerm_resource_group.rgmain.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rgmain.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "commonacr1" {
  source = "./commonacr"
  location = azurerm_resource_group.rgmain.location
  rgname = azurerm_resource_group.rgmain.name
  name = ""
}

module "commonaks1" {
  source = "./commonaks"
  location = azurerm_resource_group.rgmain.location
  rgname = azurerm_resource_group.rgmain.name
  name = ""
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "log-01"
  location            = azurerm_resource_group.rgmain.location
  resource_group_name = azurerm_resource_group.rgmain.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

