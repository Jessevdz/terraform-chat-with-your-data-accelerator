# Terraform deployment for the Azure "Chat with your data Solution accelerator repository"

This repository contains terraform code that deploys all the Azure infrastructure required by the [Microsoft Azure Chat with your data solution accelerator](https://github.com/Azure-Samples/chat-with-your-data-solution-accelerator).

It is a translation of the Bicep code contained in the "infra/" folder of the solution accelerator.

## Deployed Azure resources

The terraform code is split up into several modules, which deploy the following Azure resources:

**AI module**
* Cognitive Services Account for OpenAI
* Azure Cognitive Search Service
* GPT Model Deployment
* Embedding Model Deployment
* Form Recognizer Service
* Speech Service
* Content Safety Service

**Integration module**
* Azure Log Analytics Workspace
* Azure Application Insights
* Azure Event Grid System Topic
* Azure Event Grid System Topic Event Subscription

**Storage module**
* Azure Storage Account
* Blob Container - Default
* Blob Container - Config
* Document Processing Queue
* Document Processing Poison Queue

**Web module**
* Azure Service Plan
* Azure Linux Web App (Website)
* Azure Linux Web App (Website Admin)
* Azure Linux Function App (Backend)


## Azure setup

1. Set up an azure subscription.

2. Authenticate to Azure using the Azure CLI
```
$ az login
> ... returns subscription details

  {
     "cloudName": "AzureCloud",
     "homeTenantId": "",
     "id": "<SUBSCRIPTION_ID>",
     "isDefault": true,
     "managedByTenants": [],
     "name": "",
     "state": "Enabled",
     "tenantId": "",
     "user": {
          "name": "",
          "type": "user"
       }
  }

```

3. Set the subscription in the Azure CLI
```
$ az account set --subscription "<SUBSCRIPTION_ID>"
```

4. Create a service principal to allow Terraform to safely interact with Azure
```
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
> {
  "appId": "xxxxxx-xxx-xxxx-xxxx-xxxxxxxxxx",
  "displayName": "xxxx",
  "password": "xxxxxx~xxxxxx~xxxxx",
  "tenant": "xxxxx-xxxx-xxxxx-xxxx-xxxxx"
  }
```

5. Set the service principal and subscription ID details as environment variables

```
$ export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
$ export ARM_CLIENT_ID="<APPID_VALUE>"
$ export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
$ export ARM_TENANT_ID="<TENANT_VALUE>"
```

You can also use the provided script "set_azure_env.sh"
```
. ./set_azure_env.sh
```

## Terraform setup

### 1. In the root module:

* Customize the "prefix" and "location" variables.
  * The prefix will be prepended to the names of all deployed resources.
  * The location indicates the Azure region where you want to deploy all resources.

### 2. In the ai_module:

* [Optional] Customize the settings of the cognitive resources, such as the GPT and embedding model types.

### 3. In the web_module:

* [Optional] Customize the settings of the web applications, such as the location and names of the docker images.

## Deploy

```
$ terraform init
> ... 

$ terraform apply
> ... 
```
