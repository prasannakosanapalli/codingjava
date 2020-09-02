variable "resource_group_name" {
  description = "(Required) resource group name of private dns zone."
  type        = string
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}

variable "private_dns_zones" {
  type = map(object({
    dns_zone_name = string
    vnet_links = list(object({
      zone_to_vnet_link_name   = string
      vnet_name                = string
      zone_to_vnet_link_exists = bool
    }))
    zone_exists          = bool
    registration_enabled = bool
  }))
  description = "Map containing Private DNS Zone Objects"
}

variable "vnet_ids" {
  type        = map(string)
  description = "A map of vnet id's"
}
