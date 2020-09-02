module "PrivateLinkService" {
  source                         = "../../common-library/TerraformModules/PrivateLinkService"
  resource_group_name            = module.BaseInfrastructure.resource_group_name
  private_link_services          = var.private_link_services
  subnet_ids                     = module.BaseInfrastructure.map_subnet_ids
  frontend_ip_configurations_map = module.LoadBalancer.frontend_ip_configurations_map
  pls_additional_tags            = var.additional_tags
}
