locals {
  resource_ids = {
    mysql    = module.MySqlDatabase.mysql_server_id
    azuresql = module.AzureSqlDatabase.azuresql_server_id
    cosmosdb = module.CosmosDB.cosmosdb_id
    keyvault = module.BaseInfrastructure.key_vault_id
  }
}

module "PrivateEndpoint" {
  providers = {
    azurerm     = azurerm
    azuread     = azuread
    random      = random
    template    = template
    tls         = tls
    null        = null
    azurerm.ado = azurerm # Set this to azurerm.ado instead of azurerm if both ADO Agents and Application are in different subscription
  }
  source                  = "../../common-library/TerraformModules/PrivateEndpoint"
  private_endpoints       = var.private_endpoints
  ado_private_endpoints   = var.ado_private_endpoints
  resource_group_name     = module.BaseInfrastructure.resource_group_name
  subnet_ids              = module.BaseInfrastructure.map_subnet_ids
  vnet_ids                = module.BaseInfrastructure.map_vnet_ids
  resource_ids            = local.resource_ids
  ado_resource_group_name = var.ado_resource_group_name
  ado_vnet_name           = var.ado_vnet_name
  ado_subnet_name         = var.ado_subnet_name
  pe_additional_tags      = var.additional_tags
  dependencies            = [module.BaseInfrastructure.depended_on_kv]
}
