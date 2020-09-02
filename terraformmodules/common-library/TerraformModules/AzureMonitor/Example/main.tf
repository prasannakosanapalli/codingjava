module "AzureMonitor" {
  source                        = "../../common-library/TerraformModules/AzureMonitor"
  resource_group_name           = module.BaseInfrastructure.resource_group_name
  storage_account_ids_map       = module.BaseInfrastructure.sa_ids_map
  resource_ids                  = module.Virtualmachine.linux_vm_id_map
  law_id_map                    = module.BaseInfrastructure.law_id_map
  action_groups                 = var.action_groups
  metric_alerts                 = var.metric_alerts
  log_profiles                  = var.log_profiles
  query_rules_alerts            = var.query_rules_alerts
  azure_monitor_additional_tags = var.additional_tags
}
