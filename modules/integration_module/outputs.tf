output "appinsights_connection_string" {
  value = azurerm_application_insights.application_insights.connection_string
}

output "appinsights_instrumentation_key" {
  value = azurerm_application_insights.application_insights.instrumentation_key
}
