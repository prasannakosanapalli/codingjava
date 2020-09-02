module "StorageAccount" {
  source              = "../../common-library/TerraformModules/StorageAccount"
  resource_group_name = module.BaseInfrastructure.resource_group_name
  key_vault_id        = module.BaseInfrastructure.key_vault_id
  storage_accounts    = var.storage_accounts
  containers          = var.containers
  blobs               = var.blobs
  queues              = var.queues
  file_shares         = var.file_shares
  tables              = var.tables
  sa_additional_tags  = var.additional_tags
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
