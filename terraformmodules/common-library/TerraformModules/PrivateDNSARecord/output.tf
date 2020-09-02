# #############################################################################
# # OUTPUTS DNS A Record
# #############################################################################

output "dns_a_record_fqdn_map" {
  value       = { for a in azurerm_private_dns_a_record.this : a.name => a.fqdn... }
  description = "A Map of FQDN of the DNS A Records"
}

output "dns_a_record_ids_map" {
  value       = { for a in azurerm_private_dns_a_record.this : a.name => a.id... }
  description = "A Map of Id of the DNS A Records"
}
