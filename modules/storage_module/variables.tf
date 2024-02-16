variable "prefix" {
  description = "Resource prefix"
  type        = string
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "blob_container_name" {
  description = "Name of the blob container"
  type        = string
  default     = "documents"
}

variable "storage_account_tier" {
  description = "Defines the Tier to use for this storage account."
  type        = string
  default     = "Standard"
}
variable "storage_account_replication_type" {
  description = "Defines the type of replication to use for this storage account. "
  type        = string
  default     = "GRS"
}
variable "storage_account_kind" {
  description = "Defines the Kind of account."
  type        = string
  default     = "StorageV2"
}
