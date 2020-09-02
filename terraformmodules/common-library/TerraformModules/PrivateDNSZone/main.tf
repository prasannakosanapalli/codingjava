data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.dns_zone_additional_tags, data.azurerm_resource_group.this.tags)

  dns_zones_distinct = distinct([
    for dz in var.private_dns_zones : {
      dns_zone_name = dz.dns_zone_name
    } if(dz.zone_exists == false && dz.dns_zone_name != null)
  ])

  dns_zones = {
    for dz in local.dns_zones_distinct :
    dz.dns_zone_name => dz
  }

  zone_to_vnet_links_distinct = distinct(flatten([
    for dz in var.private_dns_zones : [
      for vnet in coalesce(dz.vnet_links, []) : {
        dns_zone_name          = dz.dns_zone_name
        zone_to_vnet_link_name = vnet.zone_to_vnet_link_name
        vnet_name              = vnet.vnet_name
        registration_enabled   = dz.registration_enabled
      } if(coalesce(vnet.zone_to_vnet_link_exists, false) == false && vnet.vnet_name != null)
    ] if(dz.zone_exists == false && dz.dns_zone_name != null)
  ]))

  zone_to_vnet_links = {
    for vnet_link in local.zone_to_vnet_links_distinct :
    "${vnet_link.dns_zone_name}_${vnet_link.vnet_name}" => vnet_link
  }
}

# -
# - Private DNS Zone
# -
resource "azurerm_private_dns_zone" "this" {
  for_each            = local.dns_zones
  name                = each.value["dns_zone_name"]
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = local.tags
}

# -
# - Private DNS Zone to VNet Link
# -
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = local.zone_to_vnet_links
  name                  = substr(coalesce(each.value.zone_to_vnet_link_name, "${each.value["dns_zone_name"]}-${each.value["vnet_name"]}-link"), 0, 80)
  resource_group_name   = data.azurerm_resource_group.this.name
  private_dns_zone_name = each.value["dns_zone_name"]
  virtual_network_id    = lookup(var.vnet_ids, each.value["vnet_name"], null)
  registration_enabled  = coalesce(each.value.registration_enabled, false)
  depends_on            = [azurerm_private_dns_zone.this]
}
