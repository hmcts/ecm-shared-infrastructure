provider "azurerm" {
  features {}
}

provider "azurerm" {
  subscription_id            = local.cft_vnet[var.env].subscription
  skip_provider_registration = "true"
  features {}
  alias = "cft_vnet"
}

locals {
  tagEnv = var.env == "aat" ? "staging" : var.env
  common_tags = {
    "environment"  = local.tagEnv
    "managedBy"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
    "application"  = var.product
    "businessArea" = var.businessArea
    "builtFrom"    = var.builtFrom
  }

  cft_vnet = {
    perftest = {
      subscription = "8a07fdcd-6abd-48b3-ad88-ff737a4b9e3c"
    }
    aat = {
      subscription = "96c274ce-846d-4e48-89a7-d528432298a7"
    }
    ithc = {
      subscription = "62864d44-5da9-4ae9-89e7-0cf33942fa09"
    }
    preview = {
      subscription = "8b6ea922-0862-443e-af15-6056e1c9b9a4"
    }
    prod = {
      subscription = "8cbc6f36-7c56-4963-9d36-739db5d00b27"
    }
    demo = {
      subscription = "d025fece-ce99-4df2-b7a9-b649d3ff2060"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = merge(local.common_tags, tomap({ "lastUpdated" = timestamp() }))
}
