module "ApplicationGateway" {
  providers = {
    azurerm     = azurerm
    azurerm.ado = azurerm # Set this to azurerm.ado instead of azurerm if both ADO Agents and Application are in different subscription
  }
  source                           = "../../common-library/TerraformModules/ApplicationGateway"
  resource_group_name              = module.BaseInfrastructure.resource_group_name
  subnet_ids                       = module.BaseInfrastructure.map_subnet_ids
  storage_account_ids_map          = module.BaseInfrastructure.sa_ids_map
  log_analytics_workspace_id       = module.BaseInfrastructure.law_id
  app_gateway_additional_tags      = var.additional_tags
  key_vault_resource_group         = var.key_vault_resource_group
  key_vault_name                   = var.key_vault_name
  application_gateways             = var.application_gateways
  waf_policies                     = var.waf_policies
  diagnostics_storage_account_name = var.diagnostics_storage_account_name
}
