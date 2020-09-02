resource_group_name = "resource_group_name" # "<resource_group_name>"

dns_a_records = {
  arecord1 = {
    a_record_name         = "azuresql-arecord"                 # <"dns+a_record_name">
    dns_zone_name         = "privatelink.database.windows.net" # <"dns_zone_name">
    ttl                   = 300                                # <time_to_live_of_the_dns_record_in_seconds>
    ip_addresses          = ["10.0.180.17"]                    # <list_of_ipv4_addresses>
    private_endpoint_name = null                               # <"name of private endpoint for which DNSARecord to be created"
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
