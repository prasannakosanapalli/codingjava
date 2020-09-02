module "AzureContainerRegistry" {
  source                   = "../../common-library/TerraformModules/AzureContainerRegistry"
  resource_group_name      = module.BaseInfrastructure.resource_group_name
  name                     = var.name
  sku                      = var.sku
  georeplication_locations = var.georeplication_locations
  admin_enabled            = var.admin_enabled
  allowed_subnet_ids       = var.allowed_subnet_ids
  acr_additional_tags      = var.additional_tags
}
