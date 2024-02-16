# Log Analytics Workspace Resource
resource "azurerm_log_analytics_workspace" "log_analytics_ws" {
  name                = "${var.prefix}-loganalytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
}

# Application Insights Resource
resource "azurerm_application_insights" "application_insights" {
  name                = "${var.prefix}-appinsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_ws.id
}

# Event Grid System Topic Resource
resource "azurerm_eventgrid_system_topic" "event_grid_system_topic" {
  name                   = "doc-processing"
  location               = var.location
  resource_group_name    = var.resource_group_name
  source_arm_resource_id = var.storage_account_id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

# Manages an EventGrid System Topic Event Subscription.
resource "azurerm_eventgrid_system_topic_event_subscription" "blob_events" {
  name                = "blob-events"
  resource_group_name = var.resource_group_name
  system_topic        = azurerm_eventgrid_system_topic.event_grid_system_topic.name

  storage_queue_endpoint {
    queue_name                            = var.doc_processing_queue_name
    storage_account_id                    = var.storage_account_id
    queue_message_time_to_live_in_seconds = -1
  }

  included_event_types = [
    "Microsoft.Storage.BlobCreated",
    "Microsoft.Storage.BlobDeleted",
  ]

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/${var.blob_container_name}/blobs/"
  }
  event_delivery_schema = "EventGridSchema"

  retry_policy {
    max_delivery_attempts = 30
    event_time_to_live    = 1440
  }
}
