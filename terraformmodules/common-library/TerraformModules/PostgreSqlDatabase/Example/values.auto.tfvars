postgresql_servers = {
  "pgsql1" = {
    name                             = "postgresvr3"
    sku_name                         = "GP_Gen5_8"
    storage_mb                       = 5120
    backup_retention_days            = 7
    enable_geo_redundant_backup      = false
    enable_auto_grow                 = true
    administrator_login              = "azure"
    administrator_login_password     = null
    version                          = "11"
    enable_ssl_enforcement           = true
    create_mode                      = "Default"
    enable_public_network_access     = false # set this to true if you want DB to be accesable via PE
    ssl_minimal_tls_version_enforced = "TLS1_2"
    allowed_subnet_names             = []   # define it as empty list if you are accessing it via PE
    start_ip_address                 = null # define it as null if you are accessing 
    end_ip_address                   = null
  }
}

postgresql_databases = {
  db1 = {
    name       = "postgresqldb1"
    server_key = "pgsql1"
  }
}

postgresql_configurations = {
  config1 = {
    name       = "config1"
    server_key = "server1"
    value      = "on"
  }
}
