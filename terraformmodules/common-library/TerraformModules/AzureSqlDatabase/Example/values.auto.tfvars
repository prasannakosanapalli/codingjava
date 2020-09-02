resource_group_name = "resource_group_name" # "<resource_group_name>"

server_name                         = "azuresql_server_name"
database_names                      = ["azuresql_database_name"]
administrator_user_name             = "admin_username"
administrator_login_password        = "admin_password"
allowed_subnet_names                = ["subnet_name"]
azuresql_version                    = "12.0"
assign_identity                     = false
max_size_gb                         = 4
sku_name                            = "BC_Gen5_2"
private_endpoint_connection_enabled = true
enable_failover_server              = false
failover_location                   = "eastus"

firewall_rules = {
  "default" = {
    name             = "azuresql-firewall-rule-default"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
