resource_group_name = "resource_group_name" # "<resource_group_name>"

private_endpoints = {
  pe1 = {
    resource_name     = "azuresql"                         # key from the resource_ids Map key-value pairs
    name              = "privateendpointazuresql"          # <"private_endpoint_name">
    subnet_name       = "proxy"                            # <"private_endpoint_subnet">    
    approval_required = false                              # <true | false>
    approval_message  = null                               # <"approval-request_message_for_manual_approval">
    group_ids         = ["sqlServer"]                      # <["group_ids_for_private_endpoint"]>
    dns_zone_name     = "privatelink.database.windows.net" # <"dns_zone_name_for_this_private_endpoint">
    zone_exists       = false                              # <true | false>
    vnet_links = [{
      zone_to_vnet_link_name   = "custom_name_for_zone_to_vnet_link" # <"dns_zone_to_virtual_network_link_name">
      vnet_name                = "jstartvmss"                        # <"virtual_network_linked_to_dns_zone">
      zone_to_vnet_link_exists = false                               # <true | false>
    }]
    registration_enabled = true # <true | false>
    dns_a_records = [{          # <list_of_dns_a_record_blocks>
      name                  = "dns_a_record_name"
      ttl                   = 300
      ip_addresses          = ["ip_address"]
      private_endpoint_name = null
    }]
  },
  pe2 = {
    resource_name     = "mysql"
    name              = "privateendpointmysql1"
    subnet_name       = "proxy"
    approval_required = false
    approval_message  = null
    group_ids         = ["mysqlServer"]
    dns_zone_name     = "privatelink.mysql.database.azure.com"
    zone_exists       = false
    vnet_links = [{
      zone_to_vnet_link_name   = "custom_name_for_zone_to_vnet_link" # <"dns_zone_to_virtual_network_link_name">
      vnet_name                = "jstartvmss"                        # <"virtual_network_linked_to_dns_zone">
      zone_to_vnet_link_exists = false                               # <true | false>
    }]
    registration_enabled = true
    dns_a_records        = null
  },
  pe3 = {
    resource_name     = "cosmosdb"
    name              = "privateendpointcosmosdb"
    subnet_name       = "proxy"
    approval_required = false
    approval_message  = null
    group_ids         = ["MongoDB"]
    dns_zone_name     = "privatelink.mongo.cosmos.azure.com"
    zone_exists       = false
    vnet_links = [{
      zone_to_vnet_link_name   = "custom_name_for_zone_to_vnet_link" # <"dns_zone_to_virtual_network_link_name">
      vnet_name                = "jstartvmss"                        # <"virtual_network_linked_to_dns_zone">
      zone_to_vnet_link_exists = false                               # <true | false>
    }]
    registration_enabled = true
    dns_a_records        = null
  },
  pe4 = {
    resource_name     = "keyvault"
    name              = "privateendpointkeyvault"
    subnet_name       = "proxy"
    approval_required = false
    approval_message  = null
    group_ids         = ["vault"]
    dns_zone_name     = "privatelink.vaultcore.azure.net"
    zone_exists       = false
    vnet_links = [{
      zone_to_vnet_link_name   = "custom_name_for_zone_to_vnet_link" # <"dns_zone_to_virtual_network_link_name">
      vnet_name                = "jstartvmss"                        # <"virtual_network_linked_to_dns_zone">
      zone_to_vnet_link_exists = false                               # <true | false>
    }]
    registration_enabled = true
    dns_a_records        = null
  }
}

ado_private_endpoints = {
  ape1 = {
    name          = "<custom_name_for_key_vault_private_endpoint_to_ado_subnet>"
    resource_name = "<key_vault_resource_name>"
    group_ids     = ["vault"]
    dns_zone_name = "privatelink.vaultcore.azure.net"
  }
}

ado_resource_group_name = "<ado_resource_group_name>"
ado_vnet_name           = "<ado_vnet_name>"
ado_subnet_name         = "<ado_subnet_name>"

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}

