# Use modules from common library whenever possible.
# Example of 3 module references

module "BaseInfrastructure" {
  source                  = "../common-library/TerraformModules/BaseInfrastructure"
  name                    = var.name
  location                = var.location
  net_prefix              = "pocnet"
  virtual_networks        = var.virtual_networks
  subnets                 = var.subnets
  route_tables            = var.route_tables
  network_security_groups = var.network_security_groups
  net_additional_tags     = var.net_additional_tags
  sku                     = var.sku               # law sku
  retention_in_days       = var.retention_in_days # law retention_in_days
  container_name          = var.container_name    # sa container names
}

module "PrivateEndpoint" {
  source                  = "../common-library/TerraformModules/PrivateEndpoint"
  private_endpoints       = var.private_endpoints
  pe_prefix               = "att"
  resource_group_name     = module.BaseInfrastructure.resourece_group_name
  location                = module.BaseInfrastructure.resourece_group_location
  subnets_ids             = module.BaseInfrastructure.private_endpoint_subnets
  private_link_service_id = module.BaseInfrastructure.sa_id
  tags                    = var.additional_tags #local.tags
}

module "LoadBalancer" {
  source              = "../common-library/TerraformModules/LoadBalancer"
  Lbs                 = var.Lbs
  lb_prefix           = "pri"
  resource_group_name = module.BaseInfrastructure.resourece_group_name
  location            = module.BaseInfrastructure.resourece_group_location
  zones               = var.zones #based on zones will change the LB sku
  subnets_ids         = [for x in module.BaseInfrastructure.map_subnets : x.id /*if x.name == "ProxySM" || x.name == "AppSrvSM"*/]
  lb_additional_tags  = var.additional_tags
  LbRules             = var.LbRules
}