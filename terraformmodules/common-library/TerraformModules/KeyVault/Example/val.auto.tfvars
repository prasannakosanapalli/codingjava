resource_group_name = "resource"

name                            = "exampletest2020"
sku_name                        = "standard"
enabled_for_deployment          = true
enabled_for_disk_encryption     = true
enabled_for_template_deployment = true
soft_delete_enabled             = true
purge_protection_enabled        = true

log_analytics_workspace_id       = "log_analytics_workspace_id"
diagnostics_storage_account_name = "diagnostics_storage_account_name"

network_acls = {
  bypass                     = "AzureServices"                                                                                                                                                                                                                        # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
  default_action             = "Deny"                                                                                                                                                                                                                                 # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
  ip_rules                   = ["10.5.0.9", "10.5.0.10"]                                                                                                                                                                                                              # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
  virtual_network_subnet_ids = ["/subscriptions/******/resourceGroups/exampletest/providers/Microsoft.Network/virtualNetworks/test/subnets/test1", "/subscriptions/******/resourceGroups/exampletest/providers/Microsoft.Network/virtualNetworks/test/subnets/test2"] # (Optional) One or more Subnet ID's which should be able to access this Key Vault.   
}

secrets = {
  secret1 = {
    name  = "key1"
    value = "value1"
  },
  secret2 = {
    name  = "key2"
    value = "value2"
  }
}

access_policies = {
  "accp1" = {
    group_names             = ["test1", "test2"]
    object_ids              = ["8341a2eedf", "8342a2eedf"]
    user_principal_names    = ["pricipal1", "principal2"]
    certificate_permissions = ["get", "list"]
    key_permissions         = ["get", "list"]
    secret_permissions      = ["get", "list"]
    storage_permissions     = ["get", "list"]
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
