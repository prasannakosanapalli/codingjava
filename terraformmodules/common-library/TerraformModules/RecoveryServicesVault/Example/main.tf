module "RecoveryServicesVault" {
  source                   = "../../common-library/TerraformModules/RecoveryServicesVault"
  resource_group_name      = module.BaseInfrastructure.resource_group_name
  rv_additional_tags       = var.additional_tags
  recovery_services_vaults = var.recovery_services_vaults
}
