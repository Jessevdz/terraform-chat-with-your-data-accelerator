output "cognitive_search_service_name" {
  value = azurerm_search_service.cognitive_search.name
}

output "cognitive_account_name" {
  value = local.cognitive_account_name
}

output "gpt_model_type" {
  value = var.gpt_model_type
}

output "embedding_model_type" {
  value = var.embedding_model_type
}

output "search_primary_key" {
  value = azurerm_search_service.cognitive_search.primary_key
}

output "openai_primary_key" {
  value = azurerm_cognitive_account.openai.primary_access_key
}

output "form_recognizer_primary_key" {
  value = azurerm_cognitive_account.form_recognizer.primary_access_key
}

output "content_safety_primary_key" {
  value = azurerm_cognitive_account.content_safety.primary_access_key
}

output "speech_service_name" {
  value = azurerm_cognitive_account.speech_service.name
}

output "speech_service_key" {
  value = azurerm_cognitive_account.speech_service.primary_access_key
}
