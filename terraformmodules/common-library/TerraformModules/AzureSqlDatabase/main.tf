resource "random_string" "this" {
  length           = 32
  special          = true
  override_special = "/@"
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags                         = merge(var.azuresql_additional_tags, data.azurerm_resource_group.this.tags)
  administrator_login_password = var.administrator_login_password == null ? random_string.this.result : var.administrator_login_password

  key_permissions         = ["get", "wrapkey", "unwrapkey"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
  storage_permissions     = ["get"]

  zone_redundant = var.sku_name != null ? ((substr(var.sku_name, 0, 2) == "BC" || substr(var.sku_name, 0, 1) == "P") ? true : false) : null
}

# -
# - Azure SQL Server
# -
resource "azurerm_mssql_server" "this" {
  name                         = var.server_name
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = data.azurerm_resource_group.this.location
  version                      = var.azuresql_version
  administrator_login          = var.administrator_login_name
  administrator_login_password = local.administrator_login_password

  # - Azure SQL Allow/Deny Public Network Access
  # - Only private endpoint connections will be allowed to access this resource if "private_endpoint_connection_enabled" variable is set to true
  public_network_access_enabled = var.private_endpoint_connection_enabled ? false : true

  dynamic "identity" {
    for_each = var.assign_identity == false ? [] : list(var.assign_identity)
    content {
      type = "SystemAssigned"
    }
  }

  lifecycle {
    ignore_changes = [administrator_login_password]
  }

  tags = local.tags
}

# -
# - Azure SQL Databases
# -
resource "azurerm_mssql_database" "this" {
  count     = length(var.database_names)
  name      = element(var.database_names, count.index)
  server_id = azurerm_mssql_server.this.id

  max_size_gb    = var.max_size_gb
  sku_name       = var.sku_name
  zone_redundant = local.zone_redundant

  tags       = local.tags
  depends_on = [azurerm_mssql_server.this]
}

# -
# - Azure SQL Server Virtual Network Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# -
resource "azurerm_sql_virtual_network_rule" "this" {
  count               = var.private_endpoint_connection_enabled == false ? length(var.allowed_subnet_names) : 0
  name                = "azuresql-vnet-rule-${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mssql_server.this.name
  subnet_id           = lookup(var.subnet_ids, element(var.allowed_subnet_names, count.index), null)
  depends_on          = [azurerm_mssql_server.this]
}

# -
# - Azure SQL Server Firewall Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# -
resource "azurerm_sql_firewall_rule" "this" {
  for_each            = var.private_endpoint_connection_enabled == false ? var.firewall_rules : {}
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mssql_server.this.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
  depends_on          = [azurerm_mssql_server.this]
}

# -
# - Create Key Vault Accesss Policy for Azure SQL MSI
# -
resource "azurerm_key_vault_access_policy" "this" {
  count        = var.assign_identity ? 1 : 0
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_mssql_server.this.identity.0.principal_id

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_mssql_server.this]
}

# -
# - Add Azure SQL Admin Login Password to Key Vault secrets
# -
resource "null_resource" "dependency_modules" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}
resource "azurerm_key_vault_secret" "azuresql_keyvault_secret" {
  name         = azurerm_mssql_server.this.name
  value        = local.administrator_login_password
  key_vault_id = var.key_vault_id
  depends_on   = [azurerm_mssql_server.this, null_resource.dependency_modules]
}

# -
# - Secondary/Failover Azure SQL Server
# -
resource "azurerm_mssql_server" "sqlserver_secondary" {
  count                        = var.enable_failover_server ? 1 : 0
  name                         = "${var.server_name}-secondary"
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = var.failover_location
  version                      = var.azuresql_version
  administrator_login          = var.administrator_login_name
  administrator_login_password = var.administrator_login_password

  lifecycle {
    ignore_changes = [administrator_login_password]
  }

  tags = local.tags
}

# -
# - Azure SQL Server Failover Group
# -
resource "azurerm_sql_failover_group" "this" {
  count               = var.enable_failover_server ? 1 : 0
  name                = "${var.server_name}-failover-group"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = azurerm_mssql_server.this.name
  databases           = azurerm_mssql_database.this.*.id

  partner_servers {
    id = element(azurerm_mssql_server.sqlserver_secondary.*.id, 0)
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}
