variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Kubernetes Cluster."
}

variable "aks_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "The Id of the Key Vault from which all Keys and Secrets should be sourced"
}

variable "dependencies" {
  type        = list(any)
  description = "Specifies the modules that the AKS Resource depends on."
  default     = []
}

variable "aks_clusters" {
  type = map(object({
    name                            = string
    sku_tier                        = string
    dns_prefix                      = string
    kubernetes_version              = string
    docker_bridge_cidr              = string
    service_address_range           = string
    dns_ip                          = string
    rbac_enabled                    = bool
    cmk_enabled                     = bool
    assign_identity                 = bool
    admin_username                  = string
    api_server_authorized_ip_ranges = list(string)
    network_plugin                  = string
    network_policy                  = string
    pod_cidr                        = string
    aks_default_pool = object({
      name                = string
      vm_size             = string
      availability_zones  = list(string)
      enable_auto_scaling = bool
      max_pods            = number
      os_disk_size_gb     = number
      subnet_name         = string
      node_count          = number
      max_count           = number
      min_count           = number
    })
    auto_scaler_profile = object({
      balance_similar_node_groups      = bool
      max_graceful_termination_sec     = number
      scale_down_delay_after_add       = string
      scale_down_delay_after_delete    = string
      scale_down_delay_after_failure   = string
      scan_interval                    = string
      scale_down_unneeded              = string
      scale_down_unready               = string
      scale_down_utilization_threshold = number
    })
    load_balancer_profile = object({
      outbound_ports_allocated  = number
      idle_timeout_in_minutes   = number
      managed_outbound_ip_count = number
      outbound_ip_address_ids   = list(string)
    })
  }))
  default = {}
}

variable "aks_extra_node_pools" {
  type = map(object({
    name                = string
    aks_key             = string
    vm_size             = string
    availability_zones  = list(string)
    enable_auto_scaling = bool
    max_pods            = number
    mode                = string
    os_disk_size_gb     = number
    subnet_name         = string
    node_count          = number
    max_count           = number
    min_count           = number
  }))
  description = "(Optional) List of additional node pools"
  default     = {}
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of network interfaces subnets"
  default     = {}
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "aks_client_id" {
  type = string
}

variable "aks_client_secret" {
  type = string
}

variable "ad_enabled" {
  type        = bool
  description = "Is ad integration enabled for the following cluster"
  default     = false
}

variable "aks_client_app_id" {
  type    = string
  default = null
}

variable "aks_server_app_id" {
  type    = string
  default = null
}

variable "aks_server_app_secret" {
  type    = string
  default = null
}
variable "mgmt_key_vault_rg" {
  type    = string
  default = ""
}

variable "mgmt_key_vault_name" {
  type    = string
  default = ""
}
