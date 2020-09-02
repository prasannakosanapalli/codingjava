module "ApplicationSecurityGroup" {
  source                              = "../../common-library/TerraformModules/ApplicationSecurityGroup"
  resource_group_name                 = module.BaseInfrastructure.resource_group_name
  app_security_groups_additional_tags = var.additional_tags
  application_security_groups         = var.application_security_groups
}
