variable "resource_group_name" {
  description = "Name of the resource group in which Firewall needs to be created"
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Firewall resources, in addition to the resource group tags."
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
}

variable "firewalls" {
  type = map(object({
    name = string
    ip_configurations = list(object({
      name        = string
      subnet_name = string
    }))
  }))
  description = "The Azure Firewalls with their properties."
}

variable "fw_network_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    action       = string
    rules = list(object({
      name                  = string
      description           = string
      source_addresses      = list(string)
      destination_ports     = list(string)
      destination_addresses = list(string)
      protocols             = list(string)
    }))
  }))
  description = "The Azure Firewall Rules with their properties."
}

variable "fw_nat_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    rules = list(object({
      name               = string
      description        = string
      source_addresses   = list(string)
      destination_ports  = list(string)
      protocols          = list(string)
      translated_address = string
      translated_port    = number
    }))
  }))
  description = "The Azure Firewall Nat Rules with their properties."
}

variable "fw_application_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    action       = string
    rules = list(object({
      name             = string
      description      = string
      source_addresses = list(string)
      fqdn_tags        = list(string)
      target_fqdns     = list(string)
      protocol = list(object({
        port = number
        type = string
      }))
    }))
  }))
  description = "The Azure Firewall Application Rules with their properties."
}
