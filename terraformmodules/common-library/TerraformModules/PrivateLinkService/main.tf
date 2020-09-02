data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.pls_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - Private Link Service
# -
resource "azurerm_private_link_service" "this" {
  for_each            = var.private_link_services
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  auto_approval_subscription_ids              = lookup(each.value, "auto_approval_subscription_ids", null)
  visibility_subscription_ids                 = lookup(each.value, "visibility_subscription_ids", null)
  load_balancer_frontend_ip_configuration_ids = list(lookup(var.frontend_ip_configurations_map, lookup(each.value, "frontend_ip_config_name", null)))

  nat_ip_configuration {
    name                       = "${each.value["name"]}_primary_pls_nat"
    private_ip_address         = lookup(each.value, "private_ip_address", null)
    private_ip_address_version = coalesce(lookup(each.value, "private_ip_address_version"), "IPv4")
    subnet_id                  = lookup(var.subnet_ids, lookup(each.value, "subnet_name", null))
    primary                    = true
  }

  tags = local.tags
}
