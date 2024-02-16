locals {
  storage_account_name = azurerm_storage_account.storage_account.name
}

# Azure Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.prefix}storage"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

# Blob container - default
resource "azurerm_storage_container" "blob_container_default" {
  name                  = "${local.storage_account_name}-default-${var.blob_container_name}"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}

# Blob container - config
resource "azurerm_storage_container" "blob_container_config" {
  name                  = "${local.storage_account_name}-default-config"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}

# Create the doc-processing Queue
resource "azurerm_storage_queue" "doc_processing" {
  name                 = "doc-processing"
  storage_account_name = local.storage_account_name
}

# Create the doc-processing-poison Queue
resource "azurerm_storage_queue" "doc_processing_poison" {
  name                 = "doc-processing-poison"
  storage_account_name = local.storage_account_name
}
