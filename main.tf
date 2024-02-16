# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.91.0"
    }
  }

  required_version = "~> 1.7.0"
}

provider "azurerm" {
  features {}
}


# Create a resource group to serve as a container for all Azure resources
resource "azurerm_resource_group" "azure_rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# Define storage resources
module "storage_module" {
  source = "./modules/storage_module"

  resource_group_name = azurerm_resource_group.azure_rg.name
  location            = azurerm_resource_group.azure_rg.location
  prefix              = var.prefix
}

# Define cognitive services resources
module "ai_module" {
  source = "./modules/ai_module"

  resource_group_name = azurerm_resource_group.azure_rg.name
  resource_group_id   = azurerm_resource_group.azure_rg.id
  location            = azurerm_resource_group.azure_rg.location
  prefix              = var.prefix
}

# Define supporting and integration services
module "integration_module" {
  source = "./modules/integration_module"

  resource_group_name       = azurerm_resource_group.azure_rg.name
  location                  = azurerm_resource_group.azure_rg.location
  prefix                    = var.prefix
  storage_account_id        = module.storage_module.storage_account_id
  doc_processing_queue_name = module.storage_module.doc_processing_queue_name
  blob_container_name       = module.storage_module.blob_container_name

}

# Define app services
module "web_module" {
  source = "./modules/web_module"

  resource_group_name             = azurerm_resource_group.azure_rg.name
  location                        = azurerm_resource_group.azure_rg.location
  prefix                          = var.prefix
  auth_type                       = var.auth_type
  cognitive_search_name           = module.ai_module.cognitive_search_service_name
  cognitive_account_name          = module.ai_module.cognitive_account_name
  gpt_model_type                  = module.ai_module.gpt_model_type
  embedding_model_type            = module.ai_module.embedding_model_type
  search_primary_key              = module.ai_module.search_primary_key
  openai_primary_key              = module.ai_module.openai_primary_key
  form_recognizer_primary_key     = module.ai_module.form_recognizer_primary_key
  content_safety_primary_key      = module.ai_module.content_safety_primary_key
  speech_service_name             = module.ai_module.speech_service_name
  speech_service_key              = module.ai_module.speech_service_key
  storage_account_name            = module.storage_module.storage_account_name
  storage_account_primary_key     = module.storage_module.storage_account_primary_key
  blob_container_name             = module.storage_module.blob_container_name
  doc_processing_queue_name       = module.storage_module.doc_processing_queue_name
  appinsights_connection_string   = module.integration_module.appinsights_connection_string
  appinsights_instrumentation_key = module.integration_module.appinsights_instrumentation_key
}
