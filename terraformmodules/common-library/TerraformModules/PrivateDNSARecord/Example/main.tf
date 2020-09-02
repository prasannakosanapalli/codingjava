module "PrivateDNSARecord" {
  source                        = "../../common-library/TerraformModules/PrivateDNSARecord"
  dns_a_records                 = var.dns_a_records
  resource_group_name           = module.BaseInfrastructure.resource_group_name
  dns_arecord_additional_tags   = var.additional_tags
  private_endpoint_ip_addresses = module.PrivateEndpoint.private_ip_addresses_map
  a_records_depends_on          = module.PrivateDNSZone
}
