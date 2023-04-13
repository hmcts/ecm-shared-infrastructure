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

module "create-updates-premium-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "create-updates-premium"
  namespace_name      = module.servicebus-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}

module "update-case-premium-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "update-case-premium"
  namespace_name      = module.servicebus-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
}

resource "azurerm_key_vault_secret" "create_updates_queue_send_conn_str_prm" {
  name         = "create-updates-queue-send-connection-string-premium"
  value        = module.create-updates-queue.primary_send_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "create_updates_queue_listen_conn_str_prm" {
  name         = "create-updates-queue-listen-connection-string-premium"
  value        = module.create-updates-queue.primary_listen_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_queue_send_conn_str_prm" {
  name         = "update-case-queue-send-connection-string-premium"
  value        = module.update-case-queue.primary_send_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_queue_listen_conn_str_prm" {
  name         = "update-case-queue-listen-connection-string-premium"
  value        = module.update-case-queue.primary_listen_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

output "create_updates_queue_primary_listen_connection_string_premium" {
  sensitive = true
  value     = module.create-updates-premium-queue.primary_listen_connection_string
}

output "create_updates_queue_primary_send_connection_string_premium" {
  sensitive = true
  value     =module.create-updates-premium-queue.primary_send_connection_string
}

output "update_case_queue_primary_listen_connection_string_premium" {
  sensitive = true
  value     =module.update-case-premium-queue.primary_listen_connection_string
}

output "update_case_queue_primary_send_connection_string_premium" {
  sensitive = true
  value     = module.update-case-premium-queue.primary_send_connection_string
}

output "queue_max_delivery_count_premium" {
  value     = var.queue_max_delivery_count
}