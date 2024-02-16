output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

output "blob_container_name" {
  value = azurerm_storage_container.blob_container_default.name
}

output "doc_processing_queue_name" {
  value = azurerm_storage_queue.doc_processing.name
}

output "storage_account_primary_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
}
