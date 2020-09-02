resource "random_string" "this" {
  length           = 32
  special          = true
  override_special = "/@"
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags                         = merge(var.mysql_additional_tags, data.azurerm_resource_group.this.tags)
  administrator_login_password = var.administrator_login_password == null ? random_string.this.result : var.administrator_login_password
}

# -
# - MY SQL Server
# -
resource "azurerm_mysql_server" "this" {
  name                = var.server_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku_name            = var.sku_name
  version             = var.mysql_version

  storage_mb                   = var.storage_mb
  backup_retention_days        = var.backup_retention_days
  auto_grow_enabled            = var.auto_grow_enabled
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode                  = var.create_mode
  creation_source_server_id    = var.creation_source_server_id
  restore_point_in_time        = var.restore_point_in_time

  administrator_login          = var.administrator_login_name
  administrator_login_password = local.administrator_login_password

  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = var.ssl_minimal_tls_version
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  # - MY SQL Allow/Deny Public Network Access
  # - Only private endpoint connections will be allowed to access this resource if "private_endpoint_connection_enabled" variable is set to true
  public_network_access_enabled = var.private_endpoint_connection_enabled ? false : true

  tags = local.tags

  lifecycle {
    ignore_changes = [administrator_login_password]
  }
}

# -
# - MY SQL Databases
# -
resource "azurerm_mysql_database" "this" {
  count               = length(var.database_names)
  name                = element(var.database_names, count.index)
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Configuration/Server Parameters
# -
resource "azurerm_mysql_configuration" "this" {
  for_each            = var.mysql_configurations
  name                = each.key
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  value               = each.value
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Virtual Network Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# - 
resource "azurerm_mysql_virtual_network_rule" "this" {
  count               = var.private_endpoint_connection_enabled == false ? length(var.allowed_subnet_names) : 0
  name                = "mysql-vnet-rule-${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  subnet_id           = lookup(var.subnet_ids, element(var.allowed_subnet_names, count.index), null)
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Firewall Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# - 
resource "azurerm_mysql_firewall_rule" "this" {
  for_each            = var.private_endpoint_connection_enabled == false ? var.firewall_rules : {}
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mysql_server.this.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - Add MY SQL Server Admin Login Password to Key Vault secrets
# - 
resource "null_resource" "dependency_modules" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}
resource "azurerm_key_vault_secret" "this" {
  name         = azurerm_mysql_server.this.name
  value        = local.administrator_login_password
  key_vault_id = var.key_vault_id
  depends_on   = [azurerm_mysql_server.this, null_resource.dependency_modules]
}

# -
# - Setup MySQL Server Diagnostic Logging - Storage Account
# -
resource "azurerm_monitor_diagnostic_setting" "log_settings_storage" {
  count              = var.enable_logs_to_storage ? 1 : 0
  name               = "logs-storage"
  target_resource_id = azurerm_mysql_server.this.id
  storage_account_id = lookup(var.storage_account_ids_map, var.diagnostics_storage_account_name)

  log {
    category = "MySqlSlowLogs"

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "MySqlAuditLogs"

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup MySQL Server Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "log_settings_log_analytics" {
  count                      = var.enable_logs_to_log_analytics ? 1 : 0
  name                       = "logs-log-analytics"
  target_resource_id         = azurerm_mysql_server.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "MySqlSlowLogs"

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "MySqlAuditLogs"

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}
