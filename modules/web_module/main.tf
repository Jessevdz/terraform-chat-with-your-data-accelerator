locals {
  azure_search_index       = "${var.prefix}-index"
  function_app_name        = "${var.prefix}-backend"
  azure_search_service     = "https://${var.cognitive_search_name}.search.windows.net"
  form_recognizer_endpoint = "https://${var.cognitive_account_name}.cognitiveservices.azure.com/"
  content_safety_endpoint  = "https://${var.cognitive_account_name}.cognitiveservices.azure.com/"
  backend_url              = "https://${local.function_app_name}.azurewebsites.net"
}

# Manages an App Service: Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-hosting-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.hosting_plan_sku
}

# Website app service
resource "azurerm_linux_web_app" "website" {
  name                = "${var.prefix}-website"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  https_only          = true
  site_config {
    application_stack {
      docker_image_name   = var.webapp_docker_image_name
      docker_registry_url = var.webapp_docker_registry
    }
    minimum_tls_version = "1.2"
  }
  app_settings = {
    APPINSIGHTS_CONNECTION_STRING        = var.appinsights_connection_string
    ORCHESTRATION_STRATEGY               = var.orchestration_strategy
    AZURE_AUTH_TYPE                      = var.auth_type
    AZURE_SEARCH_SERVICE                 = local.azure_search_service
    AZURE_SEARCH_KEY                     = var.search_primary_key
    AZURE_SEARCH_INDEX                   = local.azure_search_index
    AZURE_SEARCH_CONVERSATIONS_LOG_INDEX = var.azure_search_conversations_log_index
    AZURE_SEARCH_USE_SEMANTIC_SEARCH     = var.azure_search_use_semantic_search
    AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG  = var.azure_search_semantic_search_config
    AZURE_SEARCH_INDEX_IS_PRECHUNKED     = var.azure_search_index_is_prechunked
    AZURE_SEARCH_TOP_K                   = var.azure_search_top_k
    AZURE_SEARCH_ENABLE_IN_DOMAIN        = var.azure_search_enable_in_domain
    AZURE_SEARCH_CONTENT_COLUMNS         = var.azure_search_content_columns
    AZURE_SEARCH_FILENAME_COLUMN         = var.azure_search_filename_column
    AZURE_SEARCH_TITLE_COLUMN            = var.azure_search_title_column
    AZURE_SEARCH_URL_COLUMN              = var.azure_search_url_column
    AZURE_OPENAI_KEY                     = var.openai_primary_key
    AZURE_OPENAI_RESOURCE                = var.cognitive_account_name
    AZURE_OPENAI_MODEL                   = var.gpt_model_type
    AZURE_OPENAI_MODEL_NAME              = var.gpt_model_type
    AZURE_OPENAI_EMBEDDING_MODEL         = var.embedding_model_type
    AZURE_FORM_RECOGNIZER_ENDPOINT       = local.form_recognizer_endpoint
    AZURE_FORM_RECOGNIZER_key            = var.form_recognizer_primary_key
    AZURE_OPENAI_TEMPERATURE             = var.azure_openai_temperature
    AZURE_OPENAI_TOP_P                   = var.azure_openai_top_p
    AZURE_OPENAI_MAX_TOKENS              = var.azure_openai_max_tokens
    AZURE_OPENAI_STOP_SEQUENCE           = var.azure_openai_stop_sequence
    AZURE_OPENAI_SYSTEM_MESSAGE          = var.azure_openai_system_message
    AZURE_OPENAI_API_VERSION             = var.azure_openai_api_version
    AZURE_OPENAI_STREAM                  = var.azure_openai_stream
    AZURE_BLOB_ACCOUNT_NAME              = var.storage_account_name
    AZURE_BLOB_CONTAINER_NAME            = var.blob_container_name
    AZURE_BLOB_ACCOUNT_KEY               = var.storage_account_primary_key
    AZURE_CONTENT_SAFETY_ENDPOINT        = local.content_safety_endpoint
    AZURE_CONTENT_SAFETY_KEY             = var.content_safety_primary_key
    AZURE_SPEECH_SERVICE_NAME            = var.speech_service_name
    AZURE_SPEECH_SERVICE_KEY             = var.speech_service_key
    AZURE_SPEECH_SERVICE_REGION          = var.location
  }
  depends_on = [
    azurerm_service_plan.asp
  ]
}

# Azure function app
resource "azurerm_linux_function_app" "function_app" {
  name                          = local.function_app_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = azurerm_service_plan.asp.id
  storage_account_name          = var.storage_account_name
  storage_uses_managed_identity = true
  https_only                    = true
  site_config {
    always_on           = true
    app_command_line    = ""
    minimum_tls_version = "1.2"
    application_stack {
      docker {
        registry_url = var.backend_docker_image_registry
        image_name   = var.backend_docker_image_name
        image_tag    = "latest"
      }
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY      = var.appinsights_instrumentation_key
    FUNCTIONS_EXTENSION_VERSION         = "~4"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    AzureWebJobsStorage                 = "DefaultEndpointsProtocol=https;AccountName=${var.storage_account_name};AccountKey=${var.storage_account_primary_key};EndpointSuffix=core.windows.net"
    AZURE_AUTH_TYPE                     = var.auth_type
    AZURE_OPENAI_MODEL                  = var.gpt_model_type
    AZURE_OPENAI_EMBEDDING_MODEL        = var.embedding_model_type
    AZURE_OPENAI_RESOURCE               = var.cognitive_account_name
    AZURE_OPENAI_KEY                    = var.openai_primary_key
    AZURE_BLOB_ACCOUNT_NAME             = var.storage_account_name
    AZURE_BLOB_ACCOUNT_KEY              = var.storage_account_primary_key
    AZURE_BLOB_CONTAINER_NAME           = var.blob_container_name
    AZURE_FORM_RECOGNIZER_ENDPOINT      = local.form_recognizer_endpoint
    AZURE_FORM_RECOGNIZER_KEY           = var.form_recognizer_primary_key
    AZURE_SEARCH_SERVICE                = local.azure_search_service
    AZURE_SEARCH_KEY                    = var.search_primary_key
    DOCUMENT_PROCESSING_QUEUE_NAME      = var.doc_processing_queue_name
    AZURE_OPENAI_API_VERSION            = var.azure_openai_api_version
    AZURE_SEARCH_INDEX                  = local.azure_search_index
    ORCHESTRATION_STRATEGY              = var.orchestration_strategy
    AZURE_CONTENT_SAFETY_ENDPOINT       = local.content_safety_endpoint
    AZURE_CONTENT_SAFETY_KEY            = var.content_safety_primary_key
  }
}

# Obtain the function key
data "azurerm_function_app_host_keys" "function_key" {
  name                = local.function_app_name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_linux_function_app.function_app]
}

# Admin website app service
resource "azurerm_linux_web_app" "website_admin" {
  name                = "${var.prefix}-website-admin"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  https_only          = true
  site_config {
    application_stack {
      docker_image_name   = var.admin_webapp_docker_image_name
      docker_registry_url = var.admin_webapp_docker_registry
    }
    minimum_tls_version = "1.2"
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY      = var.appinsights_instrumentation_key
    AZURE_AUTH_TYPE                     = var.auth_type
    ORCHESTRATION_STRATEGY              = var.orchestration_strategy
    AZURE_SEARCH_SERVICE                = local.azure_search_service
    AZURE_SEARCH_KEY                    = var.search_primary_key
    AZURE_SEARCH_INDEX                  = local.azure_search_index
    AZURE_SEARCH_USE_SEMANTIC_SEARCH    = var.azure_search_use_semantic_search
    AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG = var.azure_search_semantic_search_config
    AZURE_SEARCH_INDEX_IS_PRECHUNKED    = var.azure_search_index_is_prechunked
    AZURE_SEARCH_TOP_K                  = var.azure_search_top_k
    AZURE_SEARCH_ENABLE_IN_DOMAIN       = var.azure_search_enable_in_domain
    AZURE_SEARCH_CONTENT_COLUMNS        = var.azure_search_content_columns
    AZURE_SEARCH_FILENAME_COLUMN        = var.azure_search_filename_column
    AZURE_SEARCH_TITLE_COLUMN           = var.azure_search_title_column
    AZURE_SEARCH_URL_COLUMN             = var.azure_search_url_column
    AZURE_OPENAI_RESOURCE               = var.cognitive_account_name
    AZURE_OPENAI_KEY                    = var.openai_primary_key
    AZURE_OPENAI_MODEL                  = var.gpt_model_type
    AZURE_OPENAI_MODEL_NAME             = var.gpt_model_type
    AZURE_OPENAI_TEMPERATURE            = var.azure_openai_temperature
    AZURE_OPENAI_TOP_P                  = var.azure_openai_top_p
    AZURE_OPENAI_MAX_TOKENS             = var.azure_openai_max_tokens
    AZURE_OPENAI_STOP_SEQUENCE          = var.azure_openai_stop_sequence
    AZURE_OPENAI_SYSTEM_MESSAGE         = var.azure_openai_system_message
    AZURE_OPENAI_API_VERSION            = var.azure_openai_api_version
    AZURE_OPENAI_STREAM                 = var.azure_openai_stream
    AZURE_OPENAI_EMBEDDING_MODEL        = var.embedding_model_type
    AZURE_FORM_RECOGNIZER_ENDPOINT      = local.form_recognizer_endpoint
    AZURE_FORM_RECOGNIZER_KEY           = var.form_recognizer_primary_key
    AZURE_BLOB_ACCOUNT_NAME             = var.storage_account_name
    AZURE_BLOB_ACCOUNT_KEY              = var.storage_account_primary_key
    AZURE_BLOB_CONTAINER_NAME           = var.blob_container_name
    DOCUMENT_PROCESSING_QUEUE_NAME      = var.doc_processing_queue_name
    AZURE_CONTENT_SAFETY_ENDPOINT       = local.content_safety_endpoint
    AZURE_CONTENT_SAFETY_KEY            = var.content_safety_primary_key
    FUNCTION_KEY                        = data.azurerm_function_app_host_keys.function_key.default_function_key
    BACKEND_URL                         = local.backend_url
  }
  depends_on = [
    azurerm_service_plan.asp,
    azurerm_linux_function_app.function_app
  ]
}

