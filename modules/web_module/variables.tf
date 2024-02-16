variable "prefix" {
  description = "Provide a 2-13 character prefix for all resources."
  type        = string
}

variable "location" {
  description = "Location for all resources."
  type        = string
}

variable "auth_type" {
  description = "Authentication type"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "cognitive_search_name" {
  description = "Name of the cognitive search service."
  type        = string
}

variable "cognitive_account_name" {
  description = "Name of the Cognitive Services Account"
  type        = string
}

variable "gpt_model_type" {
  description = "Name and type of the GPT model used by the openai service."
  type        = string
}

variable "embedding_model_type" {
  description = "Type of the embedding model used by the openai service."
  type        = string
}

variable "storage_account_name" {
  description = "Name of Storage Account"
  type        = string
}

variable "blob_container_name" {
  description = "Name of blob container"
  type        = string
}

variable "doc_processing_queue_name" {
  description = "queue name"
  type        = string
}

variable "appinsights_connection_string" {
  description = "The Connection String for the Application Insights component."
  type        = string
}

variable "search_primary_key" {
  description = "The Primary Key used for Search Service Administration."
  type        = string
}

variable "openai_primary_key" {
  description = "A primary access key which can be used to connect to the Cognitive Service Account."
  type        = string
}

variable "form_recognizer_primary_key" {
  description = "A primary access key which can be used to connect to the Cognitive Service Account."
  type        = string
}

variable "storage_account_primary_key" {
  description = "The primary access key for the storage account."
  type        = string
}

variable "content_safety_primary_key" {
  description = "A primary access key which can be used to connect to the Cognitive Service Account."
  type        = string
}

variable "speech_service_name" {
  description = "Name of the speech service"
  type        = string
}

variable "speech_service_key" {
  description = "A primary access key which can be used to connect to the Cognitive Service Account."
  type        = string
}

variable "appinsights_instrumentation_key" {
  description = "The Instrumentation Key for this Application Insights component."
  type        = string
}

/*
CUSTOMIZE APPLICATION SETTINGS
*/

variable "webapp_docker_image_name" {
  description = "Web application docker image name."
  type        = string
  default     = "rag-webapp:latest"
}

variable "webapp_docker_registry" {
  description = "Web application docker registry"
  type        = string
  default     = "https://fruoccopublic.azurecr.io"
}

variable "admin_webapp_docker_image_name" {
  description = "Admin web application docker image name."
  type        = string
  default     = "rag-adminwebapp:latest"
}

variable "admin_webapp_docker_registry" {
  description = "Admin web application docker registry"
  type        = string
  default     = "https://fruoccopublic.azurecr.io"
}

variable "backend_docker_image_registry" {
  description = "Backend docker image registry URL"
  type        = string
  default     = "https://fruoccopublic.azurecr.io"

}
variable "backend_docker_image_name" {
  description = "Backend docker image name"
  type        = string
  default     = "rag-backend"
}

variable "hosting_plan_sku" {
  description = "The pricing tier for the App Service plan"
  type        = string
  default     = "B3"
}

variable "azure_search_use_semantic_search" {
  description = "Use semantic search"
  type        = string
  default     = "false"
}

variable "azure_search_conversations_log_index" {
  description = "Azure AI Search Conversation Log Index"
  type        = string
  default     = "conversations"
}

variable "azure_search_semantic_search_config" {
  description = "Semantic search config"
  type        = string
  default     = "default"
}

variable "azure_search_index_is_prechunked" {
  description = "Is the index prechunked"
  type        = string
  default     = "false"
}

variable "azure_search_top_k" {
  description = "Top K results"
  type        = string
  default     = "5"
}

variable "azure_search_enable_in_domain" {
  description = "Enable in domain"
  type        = string
  default     = "false"
}

variable "azure_search_content_columns" {
  description = "Content columns"
  type        = string
  default     = "content"
}

variable "azure_search_filename_column" {
  description = "Filename column"
  type        = string
  default     = "filename"
}

variable "azure_search_title_column" {
  description = "Title column"
  type        = string
  default     = "title"
}

variable "azure_search_url_column" {
  description = "Url column"
  type        = string
  default     = "url"
}

variable "orchestration_strategy" {
  description = "Orchestration strategy: openai_function or langchain"
  type        = string
  default     = "openai_function"
}

variable "azure_openai_temperature" {
  description = "Azure OpenAI Temperature"
  type        = string
  default     = "0"
}

variable "azure_openai_top_p" {
  description = "Azure OpenAI Top P"
  type        = string
  default     = "1"
}

variable "azure_openai_max_tokens" {
  description = "Azure OpenAI Max Tokens"
  type        = string
  default     = "1000"
}

variable "azure_openai_stop_sequence" {
  description = "Azure OpenAI Stop Sequence"
  type        = string
  default     = "\n"
}

variable "azure_openai_system_message" {
  description = "Azure OpenAI System Message"
  type        = string
  default     = "You are an AI assistant that helps people find information."
}

variable "azure_openai_api_version" {
  description = "Azure OpenAI Api Version"
  type        = string
  default     = "2023-07-01-preview"
}

variable "azure_openai_stream" {
  description = "Whether or not to stream responses from Azure OpenAI"
  type        = string
  default     = "true"
}


