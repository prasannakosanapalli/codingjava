locals {
  linux_image_ids = {
    jstartvmss = var.jstartvmss # This variable need to be create with VMSS name for each VMSS while consuming this Module.
    vmss_name  = var.vmss_name
  }
}

module "VirtualmachineScaleSet" {
  source                                = "../../common-library/TerraformModules/VirtualMachineScaleSet"
  resource_group_name                   = module.BaseInfrastructure.resource_group_name
  key_vault_id                          = module.BaseInfrastructure.key_vault_id
  virtual_machine_scalesets             = var.vmss
  linux_image_ids                       = local.linux_image_ids
  custom_auto_scale_settings            = var.custom_auto_scale_settings
  administrator_user_name               = var.administrator_user_name
  administrator_login_password          = var.administrator_login_password
  subnet_ids                            = module.BaseInfrastructure.map_subnet_ids
  lb_probe_map                          = module.LoadBalancer.pri_lb_probe_map_ids
  lb_backend_address_pool_map           = module.LoadBalancer.pri_lb_backend_map_ids
  app_security_group_ids_map            = module.ApplicationSecurityGroup.app_security_group_ids_map
  application_gateway_backend_pools_map = module.ApplicationGateway.application_gateway_backend_pools_map
  sa_bootdiag_storage_uri               = module.BaseInfrastructure.primary_blob_endpoint[0]
  diagnostics_sa_name                   = module.BaseInfrastructure.sa_name[0]
  law_workspace_id                      = module.BaseInfrastructure.law_workspace_id
  law_workspace_key                     = module.BaseInfrastructure.law_key
  vmss_additional_tags                  = var.additional_tags
  lb_nat_pool_map                       = module.LoadBalancer.pri_lb_natpool_map_ids
  zones                                 = module.LoadBalancer.pri_lb_zones
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.RecoveryServicesVault.depended_on_rsv,
    module.BaseInfrastructure.depended_on_sa, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
