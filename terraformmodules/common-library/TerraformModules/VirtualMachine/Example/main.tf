locals {
  linux_image_ids = {
    nginxvm = var.nginxvm # This variable need to be create with VM name for each VM while consuming this Module.
    vm_name = var.vm_name
  }
}

module "Virtualmachine" {
  source                                   = "../../common-library/TerraformModules/VirtualMachine"
  resource_group_name                      = module.BaseInfrastructure.resource_group_name
  linux_vms                                = var.linux_vms
  linux_vm_nics                            = var.linux_vm_nics
  availability_sets                        = var.availability_sets
  linux_image_ids                          = local.linux_image_ids
  administrator_user_name                  = var.administrator_user_name
  administrator_login_password             = var.administrator_login_password
  key_vault_id                             = module.BaseInfrastructure.key_vault_id
  subnet_ids                               = module.BaseInfrastructure.map_subnet_ids
  lb_backend_address_pool_map              = module.LoadBalancer.pri_lb_backend_map_ids
  recovery_services_vaults                 = module.RecoveryServicesVault.map_recovery_vaults
  app_security_group_ids_map               = module.ApplicationSecurityGroup.app_security_group_ids_map
  application_gateway_backend_pool_ids_map = module.ApplicationGateway.application_gateway_backend_pool_ids_map
  application_gateway_backend_pools        = module.ApplicationGateway.application_gateway_backend_pools
  sa_bootdiag_storage_uri                  = module.BaseInfrastructure.primary_blob_endpoint[0]
  diagnostics_sa_name                      = module.BaseInfrastructure.sa_name[0]
  law_workspace_id                         = module.BaseInfrastructure.law_workspace_id
  law_workspace_key                        = module.BaseInfrastructure.law_key
  managed_data_disks                       = var.managed_data_disks
  lb_nat_rule_map                          = module.LoadBalancer.pri_lb_natrule_map_ids
  vm_additional_tags                       = var.additional_tags
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.RecoveryServicesVault.depended_on_rsv,
    module.BaseInfrastructure.depended_on_sa, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
