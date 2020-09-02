variable "resource_group_name" {
  description = "name of the resource group"
}

variable "flow_logs" {
  type = map(object({
    nsg_name                 = string
    storage_account_name     = string
    network_watcher_name     = string
    network_watcher_rg_name  = string
    retention_days           = string
    enable_traffic_analytics = string
    interval_in_minutes      = number
  }))
}

variable "nsg_ids_map" {
  type        = map(string)
  description = "map of nsg names with respective id's"
  default     = {}
}

variable "storage_account_ids_map" {
  type        = map(string)
  description = "map of storage names with respective id's"
  default     = {}
}

variable "workspace_id" {
  description = "log analytics work space id, required only when using traffic analytics"
  default     = null
}

variable "workspace_resource_id" {
  description = "log analytics work space resource id, required only when using traffic analytics"
  default     = null
}