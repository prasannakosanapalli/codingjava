module "ApplicationInsights" {
  source                       = "../../common-library/TerraformModules/ApplicationInsights"
  resource_group_name          = module.BaseInfrastructure.resource_group_name
  application_insights         = var.application_insights
  app_insights_additional_tags = var.additional_tags
}
