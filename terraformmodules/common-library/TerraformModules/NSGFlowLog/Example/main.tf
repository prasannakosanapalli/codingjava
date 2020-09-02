
module "nsg-flow-log" {
  source                  = "./Modules/nsg-flow-log"
  resource_group_name     = module.BaseInfrastructure.resource_group_name
  flow_logs               = var.flow_logs
  nsg_ids_map             = module.BaseInfrastructure.map_nsg_ids
  storage_account_ids_map = module.BaseInfrastructure.sa_ids_map
  workspace_id            = module.BaseInfrastructure.law_workspace_id
  workspace_resource_id   = module.BaseInfrastructure.law_id
}
