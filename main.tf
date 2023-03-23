provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "private_endpoint"
  subscription_id            = var.aks_subscription_id
}

locals {
  common_tags = {
    "environment"  = var.env
    "managedBy"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "application"  = var.product
  }

  localEnv = var.env == "preview" ? "aat" : var.env
  s2sRG  = "rpe-service-auth-provider-${local.localEnv}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = merge(local.common_tags, tomap({"lastUpdated" = timestamp()}))
}


# S2S KEY VAULT DATA
data "azurerm_key_vault" "s2s_key_vault" {
  name                = "s2s-${local.localEnv}"
  resource_group_name = local.s2sRG
}

data "azurerm_key_vault_secret" "microservicekey_ethos_repl_service" {
  name = "microservicekey-ethos-repl-service"
  key_vault_id = data.azurerm_key_vault.s2s_key_vault.id
}

# ET COS KEy VAULT
data "azurerm_key_vault" "et_cos_key_vault" {
  name                = "et-cos-${local.localEnv}"
  resource_group_name = "et-cos-${local.localEnv}"
}

data "azurerm_key_vault_secret" "et_cos_tornado" {
  name = "tornado_access_key"
  key_vault_id = data.azurerm_key_vault.et_cos_key_vault.id
}

resource "azurerm_key_vault_secret" "tornado_access_key" {
  key_vault_id = data.azurerm_key_vault.et_cos_key_vault.id
  name         = "tornado_access_key"
  value        = data.azurerm_key_vault_secret.et_cos_tornado.value
}
