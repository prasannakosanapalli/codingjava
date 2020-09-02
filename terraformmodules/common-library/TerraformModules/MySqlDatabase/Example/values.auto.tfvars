resource_group_name = "resource_group_name" # "<resource_group_name>"

server_name                         = "mysql_server_name"
database_names                      = ["mysql_database_name"]
administrator_user_name             = "admin_username"
administrator_login_password        = "admin_password"
allowed_subnet_names                = ["subnet_name"]
sku_name                            = "GP_Gen5_2"
mysql_version                       = "5.7"
create_mode                         = "Replica"
creation_source_server_id           = "source_server_id"
restore_point_in_time               = null
storage_mb                          = 5120
backup_retention_days               = 7
geo_redundant_backup_enabled        = false
auto_grow_enabled                   = true
private_endpoint_connection_enabled = true
ssl_minimal_tls_version             = "TLS1_2"
infrastructure_encryption_enabled   = false
enable_logs_to_log_analytics        = false
enable_logs_to_storage              = false
diagnostics_storage_account_name    = "<diagnostics_storage_account_name>"

firewall_rules = {
  "default" = {
    name             = "mysql-firewall-rule-default"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
  }
}

mysql_configurations = {
  interactive_timeout = "600"
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
