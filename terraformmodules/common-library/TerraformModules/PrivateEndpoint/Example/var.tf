variable "resource_group_name" {
  type        = string
  description = "Resource Group name of private endpoint. If private endpoint is crated in bastion vnet then private endpoint can only be created in bastion subscription resource group"
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}

variable "private_endpoints" {
  type = map(object({
    name                 = string
    subnet_name          = string
    resource_name        = string
    group_ids            = list(string)
    approval_required    = bool
    approval_message     = string
    dns_zone_name        = string
    zone_exists          = bool
    registration_enabled = bool
    vnet_links = list(object({
      zone_to_vnet_link_name   = string
      vnet_name                = string
      zone_to_vnet_link_exists = bool
    }))
    dns_a_records = list(object({
      name                  = string
      ttl                   = number
      ip_addresses          = list(string)
      private_endpoint_name = string
    }))
  }))
  description = "Map containing Private Endpoint and Private DNS Zone details"
}

# -
# - ADO Private Endpoint
# -
variable "ado_private_endpoints" {
  type = map(object({
    name          = string
    resource_name = string
    group_ids     = list(string)
    dns_zone_name = string
  }))
  description = "Map containing ADO Private Endpoint details"
  default     = {}
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
}

variable "vnet_ids" {
  type        = map(string)
  description = "A map of vnet id's"
}

variable "resource_ids" {
  type        = map(string)
  description = "Map of private link service resource id's"
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault resource name which is linked to ado private endpoint"
}

variable "ado_pe_kv_name" {
  type        = string
  description = "Specifies the name for ado private endpoint to workload Key Vault"
}

variable "ado_resource_group_name" {
  type        = string
  description = "Specifies the existing ado agent resource group name"
}

variable "ado_vnet_name" {
  type        = string
  description = "Specifies the existing ado agent virtual network name"
}

variable "ado_subnet_name" {
  type        = string
  description = "Specifies the existing ado agent subnet name"
}
