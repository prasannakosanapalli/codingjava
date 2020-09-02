resource_group_name = "resource_group_name" # "<resource_group_name>"

private_dns_zones = {
  zone1 = {
    dns_zone_name = "privatelink.database.windows.net" # <"dns_zone_name">
    vnet_links = [{
      zone_to_vnet_link_name   = "custom_name_for_zone_to_vnet_link" # <"dns_zone_to_virtual_network_link_name">
      vnet_name                = "jstartvmss"                        # <"virtual_network_linked_to_dns_zone">
      zone_to_vnet_link_exists = false                               # <true | false>
    }]
    zone_exists          = false # <true | false>    
    registration_enabled = true  # <true | false>
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
