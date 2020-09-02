locals {
  location = var.net_location == "" ? azurerm_resource_group.this.location : var.net_location
  tags     = merge(var.net_additional_tags, azurerm_resource_group.this.tags)
}

data "azurerm_client_config" "current" {}

data "azuread_service_principal" "this" {
  application_id = data.azurerm_client_config.current.client_id
}

# -
# - Create Resource Group
# -
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags = merge(var.mandatory_tags, {
    env          = terraform.workspace
    automated_by = data.azuread_service_principal.this.display_name
  })
}

# -
# - Virtual Network
# -
resource "azurerm_virtual_network" "this" {
  for_each            = var.virtual_networks
  name                = each.value["name"]
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = each.value["address_space"]
  dns_servers         = lookup(each.value, "dns_servers", null)

  dynamic "ddos_protection_plan" {
    for_each = lookup(each.value, "ddos_protection_plan", null) != null ? list(lookup(each.value, "ddos_protection_plan")) : []
    content {
      id     = lookup(ddos_protection_plan.value, "id", null)
      enable = coalesce(lookup(ddos_protection_plan.value, "enable"), false)
    }
  }

  tags = local.tags
}

# -
# - VNet Peering
# -
data "azurerm_virtual_network" "destination" {
  for_each            = var.vnet_peering
  name                = each.value["destination_vnet_name"]
  resource_group_name = each.value["destination_vnet_rg"]
  depends_on          = [azurerm_virtual_network.this]
}

locals {
  remote_vnet_id_map = {
    for k, v in data.azurerm_virtual_network.destination :
    v.name => v.id
  }
}

resource "azurerm_virtual_network_peering" "source_to_destination" {
  for_each                     = var.vnet_peering
  name                         = "${lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]}-to-${each.value["destination_vnet_name"]}"
  remote_virtual_network_id    = lookup(local.remote_vnet_id_map, each.value["destination_vnet_name"], null)
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]
  allow_forwarded_traffic      = coalesce(lookup(each.value, "allow_forwarded_traffic"), true)
  allow_virtual_network_access = coalesce(lookup(each.value, "allow_virtual_network_access"), true)
  allow_gateway_transit        = coalesce(lookup(each.value, "allow_gateway_transit"), false)
  use_remote_gateways          = coalesce(lookup(each.value, "use_remote_gateways"), false)
  depends_on                   = [azurerm_virtual_network.this]

  lifecycle {
    ignore_changes = [remote_virtual_network_id]
  }
}

resource "azurerm_virtual_network_peering" "destination_to_source" {
  for_each                     = var.vnet_peering
  name                         = "${each.value["destination_vnet_name"]}-to-${lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]}"
  remote_virtual_network_id    = lookup(azurerm_virtual_network.this, each.value["vnet_key"], null)["id"]
  resource_group_name          = each.value["destination_vnet_rg"]
  virtual_network_name         = each.value["destination_vnet_name"]
  allow_forwarded_traffic      = coalesce(lookup(each.value, "allow_forwarded_traffic"), true)
  allow_virtual_network_access = coalesce(lookup(each.value, "allow_virtual_network_access"), true)
  allow_gateway_transit        = coalesce(lookup(each.value, "allow_gateway_transit"), false)
  use_remote_gateways          = coalesce(lookup(each.value, "use_remote_gateways"), false)
  depends_on                   = [azurerm_virtual_network.this]
}

# -
# - Subnet
# -
resource "azurerm_subnet" "this" {
  for_each                                       = var.subnets
  name                                           = each.value["name"]
  resource_group_name                            = azurerm_resource_group.this.name
  address_prefixes                               = each.value["address_prefixes"]
  service_endpoints                              = coalesce(lookup(each.value, "pe_enable"), false) == false ? lookup(each.value, "service_endpoints", null) : null
  enforce_private_link_endpoint_network_policies = coalesce(lookup(each.value, "pe_enable"), false)
  enforce_private_link_service_network_policies  = coalesce(lookup(each.value, "pe_enable"), false)
  virtual_network_name                           = lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]

  dynamic "delegation" {
    for_each = coalesce(lookup(each.value, "delegation"), [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = coalesce(lookup(delegation.value, "service_delegation"), [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }

  depends_on = [azurerm_virtual_network.this]
}

# -
# - Route Table
# -
resource "null_resource" "dependency_modules" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}
resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = each.value["name"]
  location                      = local.location
  resource_group_name           = azurerm_resource_group.this.name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", null)

  dynamic "route" {
    for_each = lookup(each.value, "routes", [])
    content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null) == null ? lookup(var.firewall_private_ips_map, route.value.azure_firewall_name, null) : route.value.next_hop_in_ip_address
    }
  }

  tags = local.tags

  depends_on = [null_resource.dependency_modules]
}

locals {
  subnet_names_with_route_table = [
    for x in var.subnets : "${x.vnet_key}_${x.name}" if lookup(x, "rt_key", null) != null
  ]
  subnet_rt_keys_with_route_table = [
    for x in var.subnets : {
      subnet_name = x.name
      rt_key      = x.rt_key
      vnet_key    = x.vnet_key
    } if lookup(x, "rt_key", null) != null
  ]
  subnets_with_route_table = zipmap(local.subnet_names_with_route_table, local.subnet_rt_keys_with_route_table)
}

# Associates a Route Table with a Subnet within a Virtual Network
resource "azurerm_subnet_route_table_association" "this" {
  for_each       = local.subnets_with_route_table
  route_table_id = lookup(azurerm_route_table.this, each.value["rt_key"], null)["id"]
  subnet_id = [
    for x in azurerm_subnet.this : x.id if
    x.name == each.value["subnet_name"] &&
    x.virtual_network_name == "${lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]}"
  ][0]
}

# -
# - Network Security Group
# -
resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups
  name                = each.value["name"]
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", [])
    content {
      name                                       = security_rule.value["name"]
      description                                = lookup(security_rule.value, "description", null)
      protocol                                   = coalesce(security_rule.value["protocol"], "Tcp")
      direction                                  = security_rule.value["direction"]
      access                                     = coalesce(security_rule.value["access"], "Allow")
      priority                                   = security_rule.value["priority"]
      source_address_prefix                      = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes                    = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix                 = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes               = lookup(security_rule.value, "destination_address_prefixes", null)
      source_port_range                          = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges                         = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range                     = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges                    = lookup(security_rule.value, "destination_port_ranges", null)
      source_application_security_group_ids      = lookup(security_rule.value, "source_application_security_group_names", null) != null ? [for asg_name in security_rule.value.source_application_security_group_names : lookup(var.app_security_group_ids_map, asg_name)] : null
      destination_application_security_group_ids = lookup(security_rule.value, "destination_application_security_group_names", null) != null ? [for asg_name in security_rule.value.destination_application_security_group_names : lookup(var.app_security_group_ids_map, asg_name)] : null
    }
  }

  tags = merge(local.tags, coalesce(each.value.tags, {}))

  depends_on = [null_resource.dependency_modules]
}

locals {
  subnet_names_network_security_group = [
    for x in var.subnets : "${x.vnet_key}_${x.name}" if lookup(x, "nsg_key", null) != null
  ]
  subnet_nsg_keys_network_security_group = [
    for x in var.subnets : {
      subnet_name = x.name
      nsg_key     = x.nsg_key
      vnet_key    = x.vnet_key
    } if lookup(x, "nsg_key", null) != null
  ]
  subnets_network_security_group = zipmap(local.subnet_names_network_security_group, local.subnet_nsg_keys_network_security_group)
}

# Associates a Network Security Group with a Subnet within a Virtual Network
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = local.subnets_network_security_group
  network_security_group_id = lookup(azurerm_network_security_group.this, each.value["nsg_key"], null)["id"]
  subnet_id = [
    for x in azurerm_subnet.this : x.id if
    x.name == each.value["subnet_name"] &&
    x.virtual_network_name == "${lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]}"
  ][0]
}

# -
# - Log Analytics Workspace
# -
module "LogAnalytics" {
  source              = "../LogAnalytics"
  resource_group_name = azurerm_resource_group.this.name
  name                = var.base_infra_log_analytics_name
  sku                 = var.sku               # LAW SKU
  retention_in_days   = var.retention_in_days # LAW retention_in_days
  key_vault_id        = module.KeyVault.key_vault_id
  law_additional_tags = local.tags
  dependencies        = [module.KeyVault.depended_on_kv, null_resource.dependency_modules.id]
}

# -
# - Storage Account
# -
module "StorageAccount" {
  source              = "../StorageAccount"
  resource_group_name = azurerm_resource_group.this.name
  key_vault_id        = module.KeyVault.key_vault_id
  storage_accounts    = var.base_infra_storage_accounts
  containers          = var.containers
  blobs               = var.blobs
  queues              = var.queues
  file_shares         = var.file_shares
  tables              = var.tables
  sa_additional_tags  = local.tags
  dependencies        = [module.KeyVault.depended_on_kv, null_resource.dependency_modules.id]
}

# -
# - Key Vault
# -
module "KeyVault" {
  source                           = "../KeyVault"
  resource_group_name              = azurerm_resource_group.this.name
  name                             = var.base_infra_keyvault_name
  soft_delete_enabled              = var.soft_delete_enabled
  purge_protection_enabled         = var.purge_protection_enabled
  enabled_for_deployment           = var.enabled_for_deployment
  enabled_for_disk_encryption      = var.enabled_for_disk_encryption
  enabled_for_template_deployment  = var.enabled_for_template_deployment
  sku_name                         = var.sku_name
  access_policies                  = var.access_policies
  network_acls                     = var.network_acls
  log_analytics_workspace_id       = module.LogAnalytics.law_id
  storage_account_ids_map          = module.StorageAccount.sa_ids_map
  diagnostics_storage_account_name = var.diagnostics_storage_account_name
  kv_additional_tags               = local.tags
}
