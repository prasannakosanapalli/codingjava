# #############################################################################
# # OUTPUTS VNets, Subnets and NSGs
# #############################################################################

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "resource_group_location" {
  value = azurerm_resource_group.this.location
}

# VNets
output "vnet_ids" {
  value = [for x in azurerm_virtual_network.this : x.id]
}

output "map_vnet_ids" {
  value = { for x in azurerm_virtual_network.this : x.name => x.id }
}

output "vnet_names" {
  value = [for x in azurerm_virtual_network.this : x.name]
}

output "vnet_locations" {
  value = [for x in azurerm_virtual_network.this : x.location]
}

output "vnet_rgnames" {
  value = [for x in azurerm_virtual_network.this : x.resource_group_name]
}

output "private_endpoint_vnets" {
  description = ""
  value       = distinct([for s in azurerm_subnet.this : split("/subnet", s.id)[0] if(s.enforce_private_link_endpoint_network_policies != false && s.enforce_private_link_service_network_policies != false)])
}

output "map_vnets" {
  description = ""
  value       = { for k, x in azurerm_virtual_network.this : k => { "id" = x.id, "name" = x.name, "location" = x.location, resource_group_name = x.resource_group_name } }
}

# VNet Peering
output "vnet_peering_source_to_dest" {
  value = [for x in azurerm_virtual_network_peering.source_to_destination : x.id]
}

output "vnet_peering_dest_to_source" {
  value = [for x in azurerm_virtual_network_peering.destination_to_source : x.id]
}

# Subnets
output "subnet_ids" {
  value = [for x in azurerm_subnet.this : x.id]
}

output "map_subnet_ids" {
  value = { for x in azurerm_subnet.this : x.name => x.id }
}

output "subnets_with_serviceendpoints" {
  value = [
    for s in azurerm_subnet.this :
    s.id if length(coalesce(s.service_endpoints, [])) > 0
  ]
}

output "private_endpoint_subnets" {
  description = ""
  value       = distinct([for s in azurerm_subnet.this : s.id if(s.enforce_private_link_endpoint_network_policies != false && s.enforce_private_link_service_network_policies != false)])
}

output "map_subnets" {
  description = ""
  value       = { for k, b in azurerm_subnet.this : k => { "address_prefix" = b.address_prefix, "id" = b.id, "name" = b.name } }
}

# NSGs
output "network_security_group_ids" {
  value = [for x in azurerm_network_security_group.this : x.id]
}

output "map_nsg_ids" {
  value = { for x in azurerm_network_security_group.this : x.name => x.id }
}

#############################################################################
# OUTPUTS LAW
#############################################################################

output "law_workspace" {
  value = module.LogAnalytics.law_workspace
}

output "law_id" {
  value = module.LogAnalytics.law_id
}

output "law_name" {
  value = module.LogAnalytics.law_name
}

output "law_key" {
  value = module.LogAnalytics.law_key
}

output "law_workspace_id" {
  value = module.LogAnalytics.law_workspace_id
}

output "law_id_map" {
  value = module.LogAnalytics.law_id_map
}

#############################################################################
# OUTPUTS Storage Account
#############################################################################

output "sa_names" {
  value = module.StorageAccount.sa_names
}

output "sa_ids" {
  value = module.StorageAccount.sa_ids
}

output "sa_ids_map" {
  value = module.StorageAccount.sa_ids_map
}

output "primary_blob_endpoints" {
  value = module.StorageAccount.primary_blob_endpoints
}

output "primary_blob_endpoints_map" {
  value = module.StorageAccount.primary_blob_endpoints_map
}

output "primary_blob_connection_strings_map" {
value = module.StorageAccount.primary_blob_connection_strings_map
sensitive = true
}

output "primary_connection_strings" {
  value     = module.StorageAccount.primary_connection_strings
  sensitive = true
}

output "primary_connection_strings_map" {
  value     = module.StorageAccount.primary_connection_strings_map
  sensitive = true
}

output "primary_access_keys" {
  value     = module.StorageAccount.primary_access_keys
  sensitive = true
}

output "primary_access_keys_map" {
  value     = module.StorageAccount.primary_access_keys_map
  sensitive = true
}

output "container_ids" {
  value = module.StorageAccount.container_ids
}

output "blob_ids" {
  value = module.StorageAccount.blob_ids
}

output "blob_urls" {
  value = module.StorageAccount.blob_urls
}

output "file_share_ids" {
  value = module.StorageAccount.file_share_ids
}

output "file_share_urls" {
  value = module.StorageAccount.file_share_urls
}

output "depended_on_sa" {
  value = module.StorageAccount.depended_on_sa
}

#############################################################################
# OUTPUTS Key Vault
#############################################################################

output "key_vault_id" {
  value = module.KeyVault.key_vault_id
}

output "key_vault_name" {
  value       = module.KeyVault.key_vault_name
  description = "The Name of the Key Vault"
}

output "key_vault_uri" {
  value       = module.KeyVault.key_vault_uri
  description = "The URI of the Key Vault, used for performing operations on keys and secrets"
}

output "key_vault" {
  value = module.KeyVault.key_vault
}

output "key_vault_policy" {
  value = module.KeyVault.key_vault_policy
}

output "depended_on_kv" {
  value = module.KeyVault.depended_on_kv
}
