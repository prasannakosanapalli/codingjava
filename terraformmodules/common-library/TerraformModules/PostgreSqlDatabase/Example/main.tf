module "PostgreSqlDatabase" {
  resource_group_name        = module.BaseInfrastructure.resource_group_name
  postgresql_servers         = var.postgresql_servers
  postgresql_databases       = var.postgresql_databases
  key_vault_id               = module.BaseInfrastructure.key_vault_id
  subnet_ids                 = module.BaseInfrastructure.map_subnet_ids
  postgresql_configurations  = var.postgresql_configurations
  postgresql_additional_tags = var.additional_tags
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.PrivateEndpoint.depended_on_ado_pe
  ]
}

