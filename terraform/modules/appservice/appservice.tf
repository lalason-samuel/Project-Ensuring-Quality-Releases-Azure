# resource "azurerm_service_plan" "test" {
#   name                = "${var.application_type}-${var.resource_type}"
#   location            = "${var.location}"
#   resource_group_name = "${var.resource_group}"
#   os_type             = "Linux"
#   sku_name            = "F1"
# }

# resource "azurerm_linux_web_app" "test" {
#   name                = "${var.application_type}-${var.resource_type}"
#   location            = "${var.location}"
#   resource_group_name = "${var.resource_group}"
#   service_plan_id     = azurerm_service_plan.test.id

#   app_settings = {
#     "WEBSITE_RUN_FROM_PACKAGE" = 0
#   }
#   site_config {
#     always_on = false
#   }
# }

# Crée un App Service Plan
resource "azurerm_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = "eastus"
  resource_group_name = "Azuredevops"
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

# Crée un App Service
resource "azurerm_linux_web_app" "example" {
  name                = "appservice${random_string.resource_code.result}"
  location            = var.location
  resource_group_name = var.resource_group
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "example-storage-connection-string"
    type  = "Custom"
    value = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.example.name};AccountKey=${azurerm_storage_account.example.primary_access_key}"
  }
}


# Crée un compte de stockage
resource "azurerm_storage_account" "example" {
  name                     = "samistkg${random_string.resource_code.result}"
  location                 = var.location
  resource_group_name      = var.resource_group
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}
