# ECM FlexiDB
module "postgres" {
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible?ref=master"
  env    = var.env
  providers = {
    azurerm.postgres_network = azurerm.private_endpoint
  }
  product       = var.product
  component     = var.component
  business_area = var.businessArea
  common_tags   = local.common_tags
  pgsql_databases = [
    {
      name : "ecmconsumer"
    },
    {
      name : "ethos"
    }
  ]
  pgsql_version        = "15"
  admin_user_object_id = var.jenkins_AAD_objectId
}

resource "azurerm_key_vault_secret" "ecm_shared_postgres_user" {
  name         = "ecm-shared-postgres-user"
  value        = module.postgres.username
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm_shared_postgres_password" {
  name         = "ecm-shared-postgres-password"
  value        = module.postgres.password
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm_shared_postgres_host" {
  name         = "ecm-shared-postgres-host"
  value        = module.postgres.fqdn
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ecm_shared_postgres_port" {
  name         = "ecm-shared-postgres-port"
  value        = "5432"
  key_vault_id = module.key-vault.key_vault_id
}