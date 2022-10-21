terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.27.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "046c0de4-5c98-4a31-91e8-e357f68c25ab"
  tenant_id = "7214323f-fcce-49e5-bea4-0d735f2f230d"
  client_id = "a60fb653-0e45-4ed5-abe8-3880815ec632"
  client_secret = "mQ58Q~2rP69AS_8SY3KD~~YZLV2A3lYcRwL69dkm"
  features {}
}

resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "North Europe"
}

resource "azurerm_storage_account" "appstorage3456789" {
  name                     = "appstorage3456789"
  resource_group_name      = "app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "appstorage3456789"
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.appstorage3456789
  ]
}

resource "azurerm_storage_blob" "maintf" {
  name                   = "main.tf"
  storage_account_name   = "appstorage3456789"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [
    azurerm_storage_container.data
  ]
}