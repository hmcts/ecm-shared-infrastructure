provider "azurerm" {
  features {}
}

locals {
  common_tags = {
    "environment"  = var.env
    "managedBy"    = var.team_name
    "Team Contact" = var.team_contact
    "Destroy Me"   = var.destroy_me
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = merge(local.common_tags, map("lastUpdated", timestamp()))
}
