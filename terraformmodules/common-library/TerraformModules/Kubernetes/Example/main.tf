module "Kubernetes" {
  providers = {
    azurerm     = azurerm
    azurerm.ado = azurerm # Set this to azurerm.ado instead of azurerm if both ADO Agents and Application are in different subscription
  }
  source                     = "../../common-library/TerraformModules/Kubernetes"
  resource_group_name        = module.BaseInfrastructure.resource_group_name
  subnet_ids                 = module.BaseInfrastructure.map_subnet_ids
  log_analytics_workspace_id = module.BaseInfrastructure.law_id
  key_vault_id               = module.BaseInfrastructure.key_vault_id
  aks_clusters               = var.aks_clusters
  aks_extra_node_pools       = var.aks_extra_node_pools
  ad_enabled                 = var.ad_enabled
  aks_client_id              = var.client_id
  aks_client_secret          = var.client_secret
  mgmt_key_vault_name        = var.mgmt_key_vault_name
  mgmt_key_vault_rg          = var.mgmt_key_vault_rg
  aks_client_app_id          = var.aks_client_app_id
  aks_server_app_id          = var.aks_server_app_id
  aks_server_app_secret      = var.aks_server_app_secret
  aks_additional_tags        = var.additional_tags
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
