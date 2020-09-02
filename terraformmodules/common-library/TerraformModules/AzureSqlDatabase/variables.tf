variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Azure SQL Server"
}

variable "azuresql_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault resource id to store database server password"
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
}

variable "dependencies" {
  type        = list(any)
  description = "Specifies the modules that the Azure SQL Server Resource depends on."
  default     = []
}

# -
# - Azure SQL Server
# -
variable "server_name" {
  type        = string
  description = "The name of the Azure SQL Server"
}

variable "database_names" {
  type        = list(string)
  description = "List of Azure SQL database names"
}

variable "administrator_login_name" {
  type        = string
  description = "The administrator username of Azure SQL Server"
  default     = "dbadmin"
}

variable "administrator_login_password" {
  type        = string
  description = "The administrator password of the Azure SQL Server"
  default     = null
}

variable "allowed_subnet_names" {
  type        = list(string)
  description = "The list of subnet names that the Azure SQL server will be connected to"
}

variable "azuresql_version" {
  type        = string
  description = "Specifies the version of Azure SQL Server ti use. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  default     = "12.0"
}

variable "assign_identity" {
  type        = bool
  description = "Specifies whether to enable Managed System Identity for the Azure SQL Server"
  default     = false
}

variable "max_size_gb" {
  type        = number
  description = "The max size of the database in gigabytes"
  default     = null
}

variable "sku_name" {
  type        = string
  description = "Specifies the name of the sku used by the database. Changing this forces a new resource to be created. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100."
  default     = null
}

variable "firewall_rules" {
  type = map(object({
    name             = string # (Required) Specifies the name of the Azure SQL Firewall Rule. 
    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule
    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule
  }))
  description = "List of Azure SQL Server firewall rule specification"
  default = {
    "default" = {
      name             = "azuresql-firewall-rule-default"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}

variable "private_endpoint_connection_enabled" {
  type        = bool
  description = "Specify if only private endpoint connections will be allowed to access this resource"
  default     = false
}

variable "enable_failover_server" {
  type        = bool
  description = "If set to true, enable failover Azure SQL Server"
  default     = false
}

variable "failover_location" {
  type        = string
  description = "Specifies the supported Azure location where the failover Azure SQL Server exists"
  default     = null
}
