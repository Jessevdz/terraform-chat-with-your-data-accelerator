variable "prefix" {
  description = "Resource prefix"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the Storage Account"
  type        = string
}

variable "doc_processing_queue_name" {
  description = "Name of the default document processing queue"
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "Specifies the SKU of the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}

variable "blob_container_name" {
  description = "Name of the Blob Container"
  type        = string
}

variable "event_grid_system_topic_name" {
  description = "Name of the Event Grid System Topic"
  type        = string
  default     = "EventGridSystemTopicName"
}

