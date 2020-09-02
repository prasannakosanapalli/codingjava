flow_logs = {
  flowlog1 = {
    nsg_name                 = "nsg5"
    storage_account_name     = "db2017test2027"
    network_watcher_name     = "NetworkWatcher_eastus2"
    network_watcher_rg_name  = "NetworkWatcherRG"
    retention_days           = "7"
    enable_traffic_analytics = false
    interval_in_minutes      = null # required only while using traffic analytics is enabled
  }
}