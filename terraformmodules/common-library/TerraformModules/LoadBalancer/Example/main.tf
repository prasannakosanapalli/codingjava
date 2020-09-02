module "LoadBalancer" {
  source                  = "../../common-library/TerraformModules/LoadBalancer"
  load_balancers          = var.load_balancers
  resource_group_name     = module.BaseInfrastructure.resource_group_name
  subnet_ids              = module.BaseInfrastructure.map_subnet_ids
  load_balancer_rules     = var.load_balancer_rules
  load_balancer_nat_rules = var.load_balancer_nat_rules
  lb_outbound_rules       = var.lb_outbound_rules
  load_balancer_nat_pools = var.load_balancer_nat_pools
  lb_additional_tags      = var.additional_tags
}
