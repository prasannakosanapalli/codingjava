module "PrivateDNSZone" {
  source                   = "../../common-library/TerraformModules/PrivateDNSZone"
  private_dns_zones        = var.private_dns_zones
  resource_group_name      = module.BaseInfrastructure.resource_group_name
  vnet_ids                 = module.BaseInfrastructure.map_vnet_ids
  dns_zone_additional_tags = var.additional_tags
}
