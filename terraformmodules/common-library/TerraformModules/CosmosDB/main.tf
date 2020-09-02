data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.cosmosdb_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - Azure CosmosDB Account
# -
resource "azurerm_cosmosdb_account" "this" {
  name                = lookup(var.cosmosdb_account, "database_name")
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  offer_type          = coalesce(lookup(var.cosmosdb_account, "offer_type"), "Standard")
  kind                = coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB")

  enable_multiple_write_locations = coalesce(lookup(var.cosmosdb_account, "enable_multiple_write_locations"), false)
  enable_automatic_failover       = coalesce(lookup(var.cosmosdb_account, "enable_automatic_failover"), true)

  is_virtual_network_filter_enabled = coalesce(lookup(var.cosmosdb_account, "is_virtual_network_filter_enabled"), true)
  ip_range_filter                   = lookup(var.cosmosdb_account, "ip_range_filter")

  dynamic "virtual_network_rule" {
    for_each = coalesce(var.allowed_subnet_names, [])
    content {
      id = lookup(var.subnet_ids, virtual_network_rule.value, null)
    }
  }

  dynamic "capabilities" {
    for_each = coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") != null ? [coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4")] : []
    content {
      name = capabilities.value
    }
  }

  consistency_policy {
    consistency_level       = coalesce(lookup(var.cosmosdb_account, "consistency_level"), "BoundedStaleness")
    max_interval_in_seconds = coalesce(lookup(var.cosmosdb_account, "consistency_level"), "BoundedStaleness") == "BoundedStaleness" ? coalesce(lookup(var.cosmosdb_account, "max_interval_in_seconds"), 300) : null
    max_staleness_prefix    = coalesce(lookup(var.cosmosdb_account, "consistency_level"), "BoundedStaleness") == "BoundedStaleness" ? coalesce(lookup(var.cosmosdb_account, "max_staleness_prefix"), 100000) : null
  }

  geo_location {
    location          = lookup(var.cosmosdb_account, "failover_location")
    failover_priority = 1
  }

  geo_location {
    prefix            = "${lookup(var.cosmosdb_account, "database_name")}-main"
    location          = data.azurerm_resource_group.this.location
    failover_priority = 0
  }

  tags = local.tags
}

locals {
  provisionMongoDB           = (coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "MongoDBv3.4" || coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "EnableMongo") && coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB") == "MongoDB"
  provisionCassandraKeyspace = coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "EnableCassandra" && coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB") == "GlobalDocumentDB"
  provisionTable             = coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "EnableTable" && coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB") == "GlobalDocumentDB"
}

# -
# - Create Mongo DB
# -
resource "azurerm_cosmosdb_mongo_database" "this" {
  count               = local.provisionMongoDB ? 1 : 0
  name                = "cosmos-mongo-db"
  resource_group_name = data.azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.throughput
  depends_on          = [azurerm_cosmosdb_account.this]
}

# -
# - Create Mongo Collection
# -
resource "azurerm_cosmosdb_mongo_collection" "this" {
  count               = local.provisionMongoDB ? 1 : 0
  name                = "cosmos-mongo-collection"
  resource_group_name = data.azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = element(azurerm_cosmosdb_mongo_database.this.*.name, 0)
  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"
  throughput          = var.throughput
  depends_on          = [azurerm_cosmosdb_account.this, azurerm_cosmosdb_mongo_database.this]
}

# -
# - Creates Cosmos DB Cassendra Keyspace
# -
resource "azurerm_cosmosdb_cassandra_keyspace" "this" {
  count               = local.provisionCassandraKeyspace ? 1 : 0
  name                = "cosmos-cassandra-keyspace"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.throughput
  depends_on          = [azurerm_cosmosdb_account.this]
}

# -
# - Creates Cosmos DB Table
# -
resource "azurerm_cosmosdb_table" "this" {
  count               = local.provisionTable ? 1 : 0
  name                = "cosmos-table"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.throughput
  depends_on          = [azurerm_cosmosdb_account.this]
}

# -
# - Setup CosmosDB Diagnostic Logging - Storage Account
# -
resource "azurerm_monitor_diagnostic_setting" "log_settings_storage" {
  count              = var.enable_logs_to_storage ? 1 : 0
  name               = "logs-storage"
  target_resource_id = azurerm_cosmosdb_account.this.id
  storage_account_id = lookup(var.storage_account_ids_map, var.diagnostics_storage_account_name)

  log {
    category = "DataPlaneRequests"

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "MongoRequests"

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "ControlPlaneRequests"

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
# - Setup CosmosDB Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "log_settings_log_analytics" {
  count                      = var.enable_logs_to_log_analytics ? 1 : 0
  name                       = "logs-log-analytics"
  target_resource_id         = azurerm_cosmosdb_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "DataPlaneRequests"

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "MongoRequests"

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "ControlPlaneRequests"

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
