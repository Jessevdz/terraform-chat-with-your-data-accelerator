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

variable "resource_group_id" {
  description = "ID of the resource group."
  type        = string
}

/*
CUSTOMIZE OPENAI SETTINGS
*/

variable "gpt_model_type" {
  description = "Type and Name of the OpenAI GPT model."
  type        = string
  default     = "gpt-35-turbo"
}

variable "gpt_model_version" {
  description = "Version of the OpenAI GPT model."
  type        = string
  default     = "0613"
}

variable "embedding_model_type" {
  description = "Type and Name of the embedding model."
  type        = string
  default     = "text-embedding-ada-002"
}

variable "embedding_model_version" {
  description = "Version of the embedding model."
  type        = string
  default     = "2"
}

variable "cognitive_services_account_sku" {
  description = "Specifies the SKU Name for this Cognitive Service Account."
  type        = string
  default     = "S0"
}

variable "cognitive_search_service_sku" {
  description = "The SKU which should be used for this Search Service"
  type        = string
  default     = "standard"
}

variable "form_recognizer_sku" {
  description = "Specifies the SKU Name for this form recognizer"
  type        = string
  default     = "S0"
}

variable "speech_service_sku" {
  description = "Specifies the SKU Name for this speech service"
  type        = string
  default     = "S0"
}

variable "content_safety_sku" {
  description = "Specifies the SKU Name for this content safety service"
  type        = string
  default     = "S0"
}

variable "gpt_model_sku" {
  description = "The SKU Name"
  type        = string
  default     = "standard"
}

variable "embedding_model_sku" {
  description = "The SKU Name"
  type        = string
  default     = "standard"
}
