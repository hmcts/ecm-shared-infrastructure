terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.101.0"
    }
  }
}

data "azurerm_subnet" "subnet_a" {
  name                 = "core-infra-subnet-0-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}
