locals {
  subnet_names = [for s in module.BaseInfrastructure.map_subnets : s.name]
}

module "MySqlDatabase" {
  source                              = "../../common-library/TerraformModules/MySqlDatabase"
  resource_group_name                 = module.BaseInfrastructure.resource_group_name
  subnet_ids                          = module.BaseInfrastructure.map_subnet_ids
  key_vault_id                        = module.BaseInfrastructure.key_vault_id
  storage_account_ids_map             = module.BaseInfrastructure.sa_ids_map
  log_analytics_workspace_id          = module.BaseInfrastructure.law_id
  server_name                         = var.server_name
  database_names                      = var.database_names
  administrator_login_password        = var.administrator_login_password
  administrator_login_name            = var.administrator_user_name
  allowed_subnet_names                = var.allowed_subnet_names
  sku_name                            = var.sku_name
  mysql_version                       = var.mysql_version
  create_mode                         = var.create_mode
  creation_source_server_id           = var.creation_source_server_id
  restore_point_in_time               = var.restore_point_in_time
  storage_mb                          = var.storage_mb
  backup_retention_days               = var.backup_retention_days
  geo_redundant_backup_enabled        = var.geo_redundant_backup_enabled
  auto_grow_enabled                   = var.auto_grow_enabled
  private_endpoint_connection_enabled = var.private_endpoint_connection_enabled
  ssl_minimal_tls_version             = var.ssl_minimal_tls_version
  infrastructure_encryption_enabled   = var.infrastructure_encryption_enabled
  mysql_additional_tags               = var.additional_tags
  firewall_rules                      = var.firewall_rules
  mysql_configurations                = var.mysql_configurations
  enable_logs_to_storage              = var.enable_logs_to_storage
  enable_logs_to_log_analytics        = var.enable_logs_to_log_analytics
  diagnostics_storage_account_name    = var.diagnostics_storage_account_name
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
