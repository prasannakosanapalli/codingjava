data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.dns_arecord_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - DNS A Record
# -
resource "azurerm_private_dns_a_record" "this" {
  for_each            = var.dns_a_records
  name                = each.value["a_record_name"]
  zone_name           = each.value["dns_zone_name"]
  resource_group_name = data.azurerm_resource_group.this.name
  ttl                 = coalesce(lookup(each.value, "ttl"), 3600)
  records             = each.value["private_endpoint_name"] != null ? lookup(var.private_endpoint_ip_addresses, each.value["private_endpoint_name"], null) : lookup(each.value, "ip_addresses", null)
  tags                = local.tags
  depends_on          = [var.a_records_depends_on]
}
