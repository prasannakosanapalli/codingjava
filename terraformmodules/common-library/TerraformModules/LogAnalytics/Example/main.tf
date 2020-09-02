module "LogAnalytics" {
  # validate the source path before executing the module.   
  source              = "../../common-library/TerraformModules/LogAnalytics"
  resource_group_name = var.resource_group_name
  name                = var.name
  sku                 = var.sku              
  retention_in_days   = var.retention_in_days
  key_vault_id        = module.KeyVault.key_vault_id 
  law_additional_tags = var.additional_tags
  dependencies        = [module.KeyVault.depended_on_kv]
}


