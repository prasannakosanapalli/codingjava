module "AppService" {
  source                      = "../../common-library/TerraformModules/AppService"
  resource_group_name         = module.BaseInfrastructure.resource_group_name
  app_service_plans           = var.app_service_plans
  app_services                = var.app_services
  app_service_additional_tags = var.additional_tags
}