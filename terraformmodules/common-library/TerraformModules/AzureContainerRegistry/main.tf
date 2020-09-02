data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.acr_additional_tags, data.azurerm_resource_group.this.tags)

  default_network_rule_set = {
    default_action = "Deny"
    allowed_virtual_networks = [
      for s in coalesce(var.allowed_subnet_ids, []) : {
        action    = "Allow",
        subnet_id = s
      }
    ]
  }

  disable_network_rule_set = {
    default_action           = "Allow"
    allowed_virtual_networks = null
  }

  network_rule_set = var.allowed_subnet_ids != null ? local.default_network_rule_set : local.disable_network_rule_set
}

# -
# - Azure Container Registry
# -
resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  sku                      = var.sku
  admin_enabled            = coalesce(var.admin_enabled, false)
  georeplication_locations = var.georeplication_locations

  network_rule_set {
    default_action  = local.network_rule_set.default_action
    virtual_network = local.network_rule_set.allowed_virtual_networks
  }

  tags = local.tags
}
