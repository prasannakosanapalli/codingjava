variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Azure Redis Cache."
}

variable "redis_cache_additional_tags" {
  type        = map(string)
  description = "Tags of the Azure Redis Cache in addition to the resource group tag."
  default     = {}
}

variable "redis_cache_instances" {
  type = map(object({
    name                = string
    capacity            = number
    sku                 = string
    enable_non_ssl_port = bool
    minimum_tls_version = string
    subnet_name         = string
    shard_count         = number
    static_ip           = string
    patch_schedules = list(object({
      day_of_week    = string
      start_hour_utc = number
    }))
    redis_configuration = object({
      enable_authentication           = bool
      maxmemory_reserved              = number
      maxmemory_delta                 = number
      maxmemory_policy                = string
      maxfragmentationmemory_reserved = number
      rdb_backup_enabled              = bool
      rdb_backup_frequency            = number
      rdb_backup_max_snapshot_count   = number
      backup_storage_account_name     = string
    })
  }))
  description = "Map of azure redis cache instances which needs to be created in a resource group"
  default     = {}
}

variable "firewall_rules" {
  type = list(object({
    name             = string # (Required) Specifies the name of the Firewall Rule.
    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule
    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule
    redis_cache_key  = string # (Reuiqred) The redis cache instance this rule will be associated to.
  }))
  description = "List of Azure Redis Cache firewall rule specification"
  default     = []
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of subnet Id's"
  default     = {}
}

variable "primary_blob_connection_strings_map" {
  type        = map(string)
  description = "Map of storage primary blob connection strings"
  default     = {}
}
