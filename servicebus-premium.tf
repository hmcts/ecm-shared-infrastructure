module "servicebus-namespace-premium" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-${var.env}-premium"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  env                 = var.env
  common_tags         = var.common_tags
  zone_redundant      = true
  sku                 = "Premium"
}

module "create-updates-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "create-updates-premium"
  namespace_name      = module.servicebus-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}

module "update-case-queue-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "update-case-premium"
  namespace_name      = module.servicebus-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}