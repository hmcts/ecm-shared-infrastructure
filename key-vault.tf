module "key-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "${var.product}-shared-${var.env}"
  product                 = var.product
  env                     = var.env
  tenant_id               = var.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  # dcd_group_ethos_v2 group object ID
  product_group_object_id = "414c132d-5160-42b3-bbff-43a2e1daafcf"
  common_tags             = local.common_tags
  managed_identity_object_id = var.managed_identity_object_id
}