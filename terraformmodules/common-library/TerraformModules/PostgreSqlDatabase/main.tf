data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "random_string" "this" {
  length           = 32
  special          = true
  override_special = "/@"
}

locals {
  tags = merge(var.postgresql_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - PostgreSQL Server
# -
resource "azurerm_postgresql_server" "this" {
  for_each            = var.postgresql_servers
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku_name            = each.value["sku_name"]
  version             = each.value["version"]

  storage_mb                   = each.value["storage_mb"]
  backup_retention_days        = coalesce(lookup(each.value, "backup_retention_days"), 7)
  geo_redundant_backup_enabled = coalesce(lookup(each.value, "enable_geo_redundant_backup"), false)
  auto_grow_enabled            = coalesce(lookup(each.value, "enable_auto_grow"), true)
  create_mode                  = coalesce(lookup(each.value, "create_mode"), "Default")
  creation_source_server_id    = lookup(each.value, "create_mode", "Default") != "Default" ? var.creation_source_server_id : null

  administrator_login              = each.value["administrator_login"]
  administrator_login_password     = lookup(each.value, "administrator_login_password", null) == null ? random_string.this.result : each.value["administrator_login_password"]
  ssl_enforcement_enabled          = coalesce(lookup(each.value, "enable_ssl_enforcement"), true)
  public_network_access_enabled    = coalesce(lookup(each.value, "enable_public_network_access"), false)
  ssl_minimal_tls_version_enforced = coalesce(lookup(each.value, "ssl_minimal_tls_version_enforced"), "TLSEnforcementDisabled")

  tags = local.tags
}

# -
# - postgreSQL Database
# -
resource "azurerm_postgresql_database" "this" {
  for_each            = var.postgresql_databases
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = lookup(azurerm_postgresql_server.this, each.value["server_key"], null)["name"]
  charset             = "UTF8"
  collation           = "English_United States.1252"
  depends_on          = [azurerm_postgresql_server.this]
}

# -
# - Add postgreSQL Server Admin Login Password to Key Vault secrets
# - 
resource "null_resource" "dependency_modules" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}
resource "azurerm_key_vault_secret" "this" {
  for_each     = var.postgresql_servers
  name         = each.value["name"]
  value        = lookup(each.value, "administrator_login_password", null) == null ? random_string.this.result : each.value["administrator_login_password"]
  key_vault_id = var.key_vault_id
  depends_on   = [azurerm_postgresql_server.this, null_resource.dependency_modules]
}

# -
# - postgreSQL Server Configurations
# -
resource "azurerm_postgresql_configuration" "this" {
  for_each            = var.postgresql_configurations
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = lookup(azurerm_postgresql_server.this, each.value["server_key"], null)["name"]
  value               = each.value["value"]
  depends_on          = [azurerm_postgresql_server.this]
}

locals {
  servers_with_pe_access = { for k, v in var.postgresql_servers : k => v if v.enable_public_network_access == true }
}

# -
# - postgreSQL Server Virtual Network Rules
# -
resource "azurerm_postgresql_virtual_network_rule" "this" {
  for_each                             = local.servers_with_pe_access
  name                                 = "${each.value["name"]}vnetrule"
  resource_group_name                  = data.azurerm_resource_group.this.name
  server_name                          = lookup(azurerm_postgresql_server.this, each.key, null)["name"]
  subnet_id                            = lookup(var.subnet_ids, each.value["allowed_subnet_names"], null)
  ignore_missing_vnet_service_endpoint = true
  depends_on                           = [azurerm_postgresql_server.this]
}

# -
# - postgreSQL Server Firewall Rules
# -
resource "azurerm_postgresql_firewall_rule" "this" {
  for_each            = local.servers_with_pe_access
  name                = "${each.value["name"]}firewallrule"
  resource_group_name = data.azurerm_resource_group.this.name
  server_name         = lookup(azurerm_postgresql_server.this, each.key, null)["name"]
  start_ip_address    = each.value["start_ip_address"]
  end_ip_address      = each.value["end_ip_address"]
  depends_on          = [azurerm_postgresql_server.this]
}
