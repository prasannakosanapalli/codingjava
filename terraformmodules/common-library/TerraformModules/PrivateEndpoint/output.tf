# #############################################################################
# # OUTPUTS Private Endpoint, Private DNS Zone, DNS A Record
# #############################################################################

output "private_endpoint_ids" {
  value       = [for pe in azurerm_private_endpoint.this : pe.id]
  description = "Private Endpoint Id's"
}

output "private_ip_addresses" {
  value       = [for pe in azurerm_private_endpoint.this : pe.private_service_connection.*.private_ip_address]
  description = "Private Endpoint IP Addresses"
}

output "private_ip_addresses_map" {
  value       = { for pe in azurerm_private_endpoint.this : pe.name => pe.private_service_connection.*.private_ip_address }
  description = "Map of Private Endpoint IP Addresses"
}

output "dns_zone_ids" {
  value       = module.PrivateDNSZone.dns_zone_ids
  description = "Prviate DNS Zone Id's"
}

output "dns_zone_vnet_link_ids" {
  value       = module.PrivateDNSZone.dns_zone_vnet_link_ids
  description = "Resource Id's of the Private DNS Zone Virtual Network Link"
}

output "dns_a_record_fqdn_map" {
  value       = module.PrivateDNSARecord.dns_a_record_fqdn_map
  description = "A Map of FQDN of the DNS A Records"
}

output "dns_a_record_ids_map" {
  value       = module.PrivateDNSARecord.dns_a_record_ids_map
  description = "A Map of Id of the DNS A Records"
}

output "depended_on_ado_pe" {
  value = null_resource.dependency_ado_pe.id
}
