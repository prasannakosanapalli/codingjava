variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the MySQL Server"
}

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource"
}

variable "key_vault_id" {
  type        = string
  description = "(Required) Key Vault resource id to store database server password"
}

variable "subnet_ids" {
  type        = map(string)
  description = "(Required) A map of subnet id's"
}

variable "dependencies" {
  type        = list(any)
  description = "(Required) Specifies the modules that the MySql Server Resource depends on."
}

# -
# - MY SQL Server
# -
variable "server_name" {
  type        = string
  description = "(Required) The name of the MyQL Server"
}

variable "database_names" {
  type        = list(string)
  description = "(Required) List of MySQL database names"
}

variable "administrator_login_name" {
  type        = string
  description = "(Optional) The administrator username of MySQL Server"
  default     = "dbadmin"
}

variable "administrator_login_password" {
  type        = string
  description = "(Optional) The administrator password of the MySQL Server"
  default     = null
}

variable "allowed_subnet_names" {
  type        = list(string)
  description = "(Required) The list of subnet names that the MySQL server will be connected to"
  default     = []
}

variable "sku_name" {
  type        = string
  description = "(Required) Specifies the SKU Name for this MySQL Server"
  default     = "GP_Gen5_2"
}

variable "mysql_version" {
  type        = string
  description = "(Required) Specifies the version of MySQL to use. Valid values are 5.6, 5.7, and 8.0"
  default     = "5.7"
}

variable "create_mode" {
  type        = string
  description = "(Optional) The creation mode. Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore. Defaults to Default."
  default     = "Default"
}

variable "creation_source_server_id" {
  type        = string
  description = "(Optional) For creation modes other than Default, the source server ID to use."
  default     = null
}

variable "restore_point_in_time" {
  type        = string
  description = "(Optional) When create_mode is PointInTimeRestore, specifies the point in time to restore from creation_source_server_id."
  default     = null
}

variable "storage_mb" {
  type        = number
  description = "(Required) Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  default     = 5120
}

variable "backup_retention_days" {
  type        = number
  description = "(Optional) Backup retention days for the server, supported values are between 7 and 35 days."
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not supported for the Basic tier."
  default     = false
}

variable "geo_redundant_backup" {
  type        = string
  description = "(Optional) Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier."
  default     = "Disabled"
}

variable "auto_grow_enabled" {
  type        = bool
  description = "(Optional) Enable/Disable auto-growing of the storage. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is true."
  default     = true
}

variable "auto_grow" {
  type        = string
  description = "(Optional) Defines whether autogrow is enabled or disabled for the storage. Valid values are Enabled or Disabled."
  default     = "Disabled"
}

variable "mysql_configurations" {
  type        = map(any)
  description = "(Optional) Map of MySQL configuration settings to create. Key is name, value is server parameter value"
  default     = {}
}

variable "ssl_minimal_tls_version" {
  type        = string
  description = "(Optional) The minimum TLS version to support on the sever. Possible values are TLSEnforcementDisabled, TLS1_0, TLS1_1, and TLS1_2. Defaults to TLSEnforcementDisabled."
  default     = "TLSEnforcementDisabled"
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "(Optional) Whether or not infrastructure is encrypted for this server. Defaults to false. Changing this forces a new resource to be created."
  default     = false
}

variable "firewall_rules" {
  type = map(object({
    name             = string # (Required) Specifies the name of the MySQL Firewall Rule. 
    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule
    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule
  }))
  description = "(Optional) List of MySQL Server firewall rule specification"
  default = {
    "default" = {
      name             = "mysql-firewall-rule-default"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}

variable "private_endpoint_connection_enabled" {
  type        = bool
  description = "(Optional) Specify if only private endpoint connections will be allowed to access this resource. Defaults to true."
  default     = true
}

variable "enable_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics"
  default     = false
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the Id of a Log Analytics Workspace where Diagnostics Data should be sent"
  default     = null
}

variable "enable_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account"
  default     = false
}

variable "storage_account_ids_map" {
  type        = map(string)
  description = "Map of Storage Account Id's"
  default     = {}
}

variable "diagnostics_storage_account_name" {
  type        = string
  description = "Specifies the name of the Storage Account where Diagnostics Data should be sent"
  default     = null
}
