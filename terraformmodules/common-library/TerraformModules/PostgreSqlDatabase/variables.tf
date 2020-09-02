variable "resource_group_name" {
  type        = string
  description = "Specifies the Name of the resource group in which PostgreSql should be deployed"
}

variable "postgresql_additional_tags" {
  type        = map(string)
  description = "Additional resource tags for PostgreSql Server"
  default     = {}
}

variable "dependencies" {
  type        = list(any)
  description = "Specifies the modules that the PostgreSql Server Resource depends on."
  default     = []
}

# -
# - PostgreSQL Server
# -
variable "postgresql_servers" {
  type = map(object({
    name                             = string
    sku_name                         = string
    storage_mb                       = number
    backup_retention_days            = number
    enable_geo_redundant_backup      = bool
    enable_auto_grow                 = bool
    administrator_login              = string
    administrator_login_password     = string
    version                          = number
    enable_ssl_enforcement           = bool
    create_mode                      = string
    enable_public_network_access     = bool
    ssl_minimal_tls_version_enforced = string
    allowed_subnet_names             = list(string)
    start_ip_address                 = string
    end_ip_address                   = string
  }))
  description = "Specifies the map of attributes for PostgreSql Server."
  default     = {}
}

# -
# - PostgreSQL Database
# -
variable "postgresql_databases" {
  type = map(object({
    name       = string
    server_key = string
  }))
  description = "Specifies the map of attributes for PostgreSql Database."
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "resource id of the key vault in which admin login password needs to be stored "
  default     = null
}

variable "postgresql_configurations" {
  type = map(object({
    name       = string
    server_key = string
    value      = string
  }))
  description = "Specifies the PostgreSql Configurations"
  default     = {}
}

variable "subnet_ids" {
  type        = map(string)
  description = "Specifies the Map of subnet id's"
  default     = {}
}

variable "creation_source_server_id" {
  type        = string
  description = "For creation modes other then default the source server ID to use."
  default     = null
}