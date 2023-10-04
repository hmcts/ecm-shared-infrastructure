module "queue-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-servicebus-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.common_tags
}

module "create-updates-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "create-updates"
  namespace_name      = module.queue-namespace.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}

module "update-case-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "update-case"
  namespace_name      = module.queue-namespace.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}

