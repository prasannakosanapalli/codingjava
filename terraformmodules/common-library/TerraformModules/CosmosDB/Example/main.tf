locals {
  subnet_names = [for s in module.BaseInfrastructure.map_subnets : s.name]
}

module "CosmosDB" {
  source                           = "../../common-library/TerraformModules/CosmosDB"
  resource_group_name              = module.BaseInfrastructure.resource_group_name
  subnet_ids                       = module.BaseInfrastructure.map_subnet_ids
  storage_account_ids_map          = module.BaseInfrastructure.sa_ids_map
  log_analytics_workspace_id       = module.BaseInfrastructure.law_id
  allowed_subnet_names             = var.allowed_subnet_names
  cosmosdb_account                 = var.cosmosdb_account
  throughput                       = var.throughput
  enable_logs_to_storage           = var.enable_logs_to_storage
  enable_logs_to_log_analytics     = var.enable_logs_to_log_analytics
  diagnostics_storage_account_name = var.diagnostics_storage_account_name
  cosmosdb_additional_tags         = var.additional_tags
}
