provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  alias                           = "private_endpoint"
  subscription_id                 = var.aks_subscription_id
}

locals {
  env_map = {
    aat      = "staging"
    perftest = "testing"
    prod     = "production"
  }

  tagEnv = lookup(local.env_map, var.env, var.env)
  common_tags = {
    "environment"  = local.tagEnv
    "managedBy"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "application"  = var.product
    "businessArea" = var.businessArea
    "builtFrom"    = var.builtFrom
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = merge(local.common_tags, tomap({ "lastUpdated" = timestamp() }))
  lifecycle {
    ignore_changes = all
  }
}
