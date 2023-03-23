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
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = merge(local.common_tags, tomap({"lastUpdated" = timestamp()}))
}

data "azurerm_postgresql_server" "ethos_postgres_database" {
  name                = "ethos-postgres-db-${var.env}"
  resource_group_name = "ethos-postgres-db-${var.env}"
}

resource "azurerm_key_vault_secret" "POSTGRES-USER" {
  name         = "${var.component}-POSTGRES-USER"
  value        = data.azurerm_postgresql_server.ethos_postgres_database.user_name
  key_vault_id = module.key-vault.key_vault_id
}

