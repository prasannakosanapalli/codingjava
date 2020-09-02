#Define all environment specific variables here

# - Vnet Peering To Destination Vnet, Source VNet reference  to Key Name in virtual Network Variable
vnet_peering = {
  vnet_peering1={
    destination_vnet_name = "destination_vnet_name"
    destination_vnet_rg = "destination_vnet_rg"
    vnetname = "virtual_networks1"
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit = false
    use_remote_gateways = false
  }
}