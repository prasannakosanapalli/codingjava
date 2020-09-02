data "azurerm_resource_group" "this" {
  for_each = var.flow_logs
  name     = each.value["network_watcher_rg_name"]
}

resource "azurerm_network_watcher_flow_log" "this" {
  for_each             = var.flow_logs
  network_watcher_name = each.value["network_watcher_name"]
  resource_group_name  = lookup(data.azurerm_resource_group.this, each.key)["name"]

  network_security_group_id = lookup(var.nsg_ids_map, lookup(each.value, "nsg_name"))
  storage_account_id        = lookup(var.storage_account_ids_map, lookup(each.value, "storage_account_name"))
  enabled                   = true

  retention_policy {
    enabled = true
    days    = coalesce(lookup(each.value, "retention_days"), 7)
  }

  dynamic "traffic_analytics" {
    for_each = coalesce(lookup(each.value, "enable_traffic_analytics"), false) == true ? list(lookup(each.value, "interval_in_minutes", 7)) : []
    content {
      enabled               = true
      workspace_id          = var.workspace_id
      workspace_region      = lookup(data.azurerm_resource_group.this, each.key)["location"]
      workspace_resource_id = var.workspace_resource_id
      interval_in_minutes   = coalesce(lookup(each.value, "interval_in_minutes"), null)
    }
  }
}