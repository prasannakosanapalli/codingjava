variable "resource_group_name" {
  type        = string
  description = "Resource Group name of private endpoint. If private endpoint is crated in bastion vnet then private endpoint can only be created in bastion subscription resource group"
}

variable "pe_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "dependencies" {
  type        = list(any)
  description = "Specifies the modules that the Private Endpoint Resource depends on."
  default     = []
}

# -
# - Private Endpoint
# -
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
  default     = {}
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
  description = "Map containing Private Endpoint and Private DNS Zone details"
  default     = {}
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
  default     = {}
}

variable "vnet_ids" {
  type        = map(string)
  description = "A map of vnet id's"
  default     = {}
}

variable "resource_ids" {
  type        = map(string)
  description = "Map of private link service resource id's"
  default     = {}
}

variable "approval_message" {
  type        = string
  description = "A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource"
  default     = "Please approve my private endpoint connection request"
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
