locals {
  cognitive_account_name = "${var.prefix}openai"
}

# Manages a Cognitive Services Account.
resource "azurerm_cognitive_account" "openai" {
  name                  = local.cognitive_account_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = var.cognitive_services_account_sku
  custom_subdomain_name = local.cognitive_account_name

  identity {
    type = "SystemAssigned"
  }
}

# Azure Cognitive search service
resource "azurerm_search_service" "cognitive_search" {
  name                         = "${var.prefix}-search"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  sku                          = var.cognitive_search_service_sku
  replica_count                = 1
  partition_count              = 1
  authentication_failure_mode  = "http401WithBearerChallenge"
  local_authentication_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = {
    deployment = "chatwithyourdata-sa"
  }
}

# GPT model
resource "azurerm_cognitive_deployment" "gpt_deployment" {
  name                 = var.gpt_model_type
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = var.gpt_model_type
    version = var.gpt_model_version
  }

  scale {
    type     = var.gpt_model_sku
    capacity = 30
  }
}

# Embedding model
resource "azurerm_cognitive_deployment" "embedding_deployment" {
  name                 = var.embedding_model_type
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = var.embedding_model_type
    version = var.embedding_model_version
  }

  scale {
    type     = var.embedding_model_sku
    capacity = 30
  }

  depends_on = [
    azurerm_cognitive_deployment.gpt_deployment,
  ]
}

# Form recognizer
resource "azurerm_cognitive_account" "form_recognizer" {
  name                  = "${var.prefix}-formrecog"
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "FormRecognizer"
  sku_name              = var.form_recognizer_sku
  custom_subdomain_name = local.cognitive_account_name

  network_acls {
    default_action = "Allow"
  }
}

# Speech service
resource "azurerm_cognitive_account" "speech_service" {
  name                  = "${var.prefix}-speechservice"
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "SpeechServices"
  sku_name              = var.speech_service_sku
  custom_subdomain_name = local.cognitive_account_name

  network_acls {
    default_action = "Allow"
  }
}

# Content safety service
resource "azurerm_cognitive_account" "content_safety" {
  name                  = "${var.prefix}-contentsafety"
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "ContentSafety"
  sku_name              = var.content_safety_sku
  custom_subdomain_name = local.cognitive_account_name

  network_acls {
    default_action = "Allow"
  }
}
