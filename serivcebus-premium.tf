module "servicebus-namespace-premium" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }

  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${var.product}-${var.env}-premium"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  env                 = var.env
  sku                 = "Premium"
  capacity            = 1
  zone_redundant      = true
  common_tags         = var.common_tags
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "create-updates-premium-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "create-updates"
  namespace_name      = module.servicebus-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "update-case-premium-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                = "update-case"
  namespace_name      = module.servicebus-namespace-premium.name
  resource_group_name = azurerm_resource_group.rg.name

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT59M"
  lock_duration                           = "PT5M"
  max_delivery_count                      = var.queue_max_delivery_count
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# region connection strings and other shared queue information as Key Vault secrets
resource "azurerm_key_vault_secret" "create_updates__premium_queue_send_conn_str" {
  name         = "create-updates-premium-queue-send-connection-string"
  value        = module.create-updates-premium-queue.primary_send_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "create_updates__premium_queue_listen_conn_str" {
  name         = "create-updates--premium-queue-listen-connection-string"
  value        = module.create-updates-premium-queue.primary_listen_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "create_updates_premium_queue_max_delivery_count" {
  name         = "create-updates-premium-queue-max-delivery-count"
  value        = var.queue_max_delivery_count
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_premium_queue_send_conn_str" {
  name         = "update-case-premium-queue-send-connection-string"
  value        = module.update-case-premium-queue.primary_send_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_premium_queue_listen_conn_str" {
  name         = "update-case-premium-queue-listen-connection-string"
  value        = module.update-case-premium-queue.primary_listen_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "update_case_premium_queue_max_delivery_count" {
  name         = "update-case-premium-queue-max-delivery-count"
  value        = var.queue_max_delivery_count
  key_vault_id = module.key-vault.key_vault_id
}