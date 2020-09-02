module "Firewall" {
  source                   = "../../common-library/TerraformModules/AzureFirewall"
  resource_group_name      = module.BaseInfrastructure.resource_group_name # var.resource_group_name
  subnet_ids               = module.BaseInfrastructure.map_subnet_ids
  firewalls                = var.firewalls
  fw_network_rules         = var.fw_network_rules
  fw_nat_rules             = var.fw_nat_rules
  fw_application_rules     = var.fw_application_rules
  firewall_additional_tags = var.additional_tags
}
