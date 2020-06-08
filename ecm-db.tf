module "ecm-database" {
  source             = "git@github.com:hmcts/cnp-module-postgres?ref=master"
  product            = "${var.product}-shared-ecm-db"
  location           = var.location
  env                = var.env
  postgresql_user    = "ecmconsumer"
  database_name      = "ecmconsumer"
  postgresql_version = "11"
  sku_name           = "GP_Gen5_2"
  sku_tier           = "GeneralPurpose"
  storage_mb         = "51200"
  common_tags        = local.common_tags
  subscription       = var.subscription
}

resource "azurerm_key_vault_secret" "ecm_postgres_user" {
  name         = "ecm-consumer-postgres-user"
  value        = module.ecm-database.user_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm_postgres_password" {
  name         = "ecm-consumer-postgres-password"
  value        = module.ecm-database.postgresql_password
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm_postgres_host" {
  name         = "ecm-consumer-postgres-host"
  value        = module.ecm-database.host_name
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm_postgres_port" {
  name         = "ecm-consumer-postgres-port"
  value        = module.ecm-database.postgresql_listen_port
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm_postgres_database" {
  name         = "ecm-consumer-postgres-database"
  value        = module.ecm-database.postgresql_database
  key_vault_id = module.key-vault.key_vault_id
}