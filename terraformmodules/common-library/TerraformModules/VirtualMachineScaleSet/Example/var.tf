variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags of the vmss in addition to the resource group tag"
}

variable "dependencies" {
  type        = list(any)
  description = "Specifies the modules that the Virtual Machine Scale Set Resource depends on."
}

# -
# - Virtual Machine Scaleset
# -
variable "virtual_machine_scalesets" {
  type = map(object({
    name                               = string
    vm_size                            = string
    zones                              = list(string)
    assign_identity                    = bool
    subnet_name                        = string
    app_security_group_names           = list(string)
    lb_backend_pool_names              = list(string)
    lb_nat_pool_names                  = list(string)
    app_gateway_name                   = string
    lb_probe_name                      = string
    enable_rolling_upgrade             = bool
    instances                          = number
    disable_password_authentication    = bool
    enable_default_auto_scale_settings = bool
    source_image_reference_publisher   = string
    source_image_reference_offer       = string
    source_image_reference_sku         = string
    source_image_reference_version     = string
    storage_os_disk_caching            = string
    managed_disk_type                  = string
    disk_size_gb                       = number
    write_accelerator_enabled          = bool
    enable_cmk_disk_encryption         = bool
    enable_accelerated_networking      = bool
    enable_ip_forwarding               = bool
    custom_data_path                   = string
    custom_data_args                   = map(string)
    diagnostics_storage_config_path    = string
    storage_profile_data_disks = list(object({
      lun                       = number
      caching                   = string
      disk_size_gb              = number
      managed_disk_type         = string
      write_accelerator_enabled = bool
    }))
    rolling_upgrade_policy = object({
      max_batch_instance_percent              = number
      max_unhealthy_instance_percent          = number
      max_unhealthy_upgraded_instance_percent = number
      pause_time_between_batches              = string
    })
    custom_script = object({
      commandToExecute   = string
      scriptPath         = string
      scriptArgs         = map(string)
      fileUris           = list(string)
      storageAccountName = string
    })
  }))
  description = "Map containing Linux VM Scaleset objects"
}

variable "custom_auto_scale_settings" {
  type = map(object({
    name              = string
    vmss_key          = string
    profile_name      = string
    default_instances = number
    minimum_instances = number
    maximum_instances = number
    rule = list(object({
      metric_name      = string
      time_grain       = string
      statistic        = string
      time_window      = string
      time_aggregation = string
      operator         = string
      threshold        = number
      direction        = string
      type             = string
      value            = string
      cooldown         = string
    }))
  }))
  description = "Map containing Linux VM Scaleset Auto Scale Settings objects"
}

variable "administrator_user_name" {
  type        = string
  description = "The username of the local administrator on each Virtual Machine Scale Set instance"
}

variable "administrator_login_password" {
  type        = string
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
}

variable "zones" {
  type        = list(string)
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of network interfaces subnets"
}

variable "app_security_group_ids_map" {
  type        = map(string)
  description = "Specifies the Map of network interfaces Application Security Group Id's"
}

variable "lb_backend_address_pool_map" {
  type        = map(string)
  description = "Map of network interfaces internal load balancers backend pool id's"
}

variable "lb_nat_pool_map" {
  type        = map(string)
  description = "Map of network interfaces to LB NAT pools"
  default     = {}
}

variable "lb_probe_map" {
  type        = map(string)
  description = "Map of network interfaces internal load balancers health probe id's"
}

variable "application_gateway_backend_pools_map" {
  type        = map(list(string))
  description = "Specifies the Map of network interfaces Application Gateway Backend Address Pool Id's"
}

variable "linux_image_ids" {
  type        = map(string)
  description = "Specifies the Map of image Id's from which the Virtual Machines should be created."
}

# Boot Diagnostics
variable "sa_bootdiag_storage_uri" {
  type        = string
  description = "Azure Storage Account Primary Queue Service Endpoint"
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault from which all Secrets should be sourced"
}

# Diagnostics Extensions
variable "diagnostics_sa_name" {
  type        = string
  description = "The name of diagnostics storage account"
}

variable "law_workspace_id" {
  type        = string
  description = "Log analytics workspace resource workspace id"
}

variable "law_workspace_key" {
  type        = string
  description = "Log analytics workspace primary shared key"
}
