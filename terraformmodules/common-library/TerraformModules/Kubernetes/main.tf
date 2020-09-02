provider "azurerm" {
  alias = "ado"
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.aks_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - Get the current user/app config
# -
data "azurerm_client_config" "current" {}

# -
# - Generate Private/Public SSH Key for AKS Nodes
# -
resource "tls_private_key" "this" {
  for_each  = var.aks_clusters
  algorithm = "RSA"
  rsa_bits  = 2048
}

# -
# - Store Generated Private SSH Key to Key Vault Secrets
# -
resource "azurerm_key_vault_secret" "this" {
  for_each     = var.aks_clusters
  name         = each.value["name"]
  value        = lookup(tls_private_key.this, each.key)["private_key_pem"]
  key_vault_id = var.key_vault_id
  depends_on = [
    null_resource.dependency_modules
  ]
}

data "azurerm_key_vault" "mgmtkeyvault" {
  provider            = azurerm.ado
  count               = (var.ad_enabled == true ? 1 : 0)
  name                = var.mgmt_key_vault_name
  resource_group_name = var.mgmt_key_vault_rg
}

data "azurerm_key_vault_secret" "aks_server_app_id" {
  provider     = azurerm.ado
  count        = (var.ad_enabled == true ? 1 : 0)
  name         = var.aks_server_app_id
  key_vault_id = data.azurerm_key_vault.mgmtkeyvault[0].id
}

data "azurerm_key_vault_secret" "aks_server_app_secret" {
  provider     = azurerm.ado
  count        = (var.ad_enabled == true ? 1 : 0)
  name         = var.aks_server_app_secret
  key_vault_id = data.azurerm_key_vault.mgmtkeyvault[0].id
}

data "azurerm_key_vault_secret" "aks_client_app_id" {
  provider     = azurerm.ado
  count        = (var.ad_enabled == true ? 1 : 0)
  name         = var.aks_client_app_id
  key_vault_id = data.azurerm_key_vault.mgmtkeyvault[0].id
}

resource "azurerm_kubernetes_cluster" "this" {
  for_each                = var.aks_clusters
  name                    = each.value["name"]
  resource_group_name     = data.azurerm_resource_group.this.name
  location                = data.azurerm_resource_group.this.location
  sku_tier                = lookup(each.value, "sku_tier", null)
  dns_prefix              = each.value["dns_prefix"]
  private_cluster_enabled = true
  kubernetes_version      = each.value["kubernetes_version"]
  disk_encryption_set_id  = coalesce(lookup(each.value, "cmk_enabled"), false) == true ? lookup(azurerm_disk_encryption_set.this, each.key)["id"] : null

  api_server_authorized_ip_ranges = lookup(each.value, "api_server_authorized_ip_ranges", null)

  dynamic "default_node_pool" {
    for_each = list(each.value["aks_default_pool"])
    content {
      name                = default_node_pool.value.name
      vm_size             = default_node_pool.value.vm_size
      availability_zones  = lookup(default_node_pool.value, "availability_zones", null)
      enable_auto_scaling = coalesce(default_node_pool.value.enable_auto_scaling, true)
      max_pods            = lookup(default_node_pool.value, "max_pods", null)
      os_disk_size_gb     = lookup(default_node_pool.value, "os_disk_size_gb", null)
      type                = "VirtualMachineScaleSets"
      node_count          = coalesce(default_node_pool.value.enable_auto_scaling, true) == true ? lookup(default_node_pool.value, "node_count", null) : default_node_pool.value.node_count
      min_count           = coalesce(default_node_pool.value.enable_auto_scaling, true) == true ? default_node_pool.value.min_count : null
      max_count           = coalesce(default_node_pool.value.enable_auto_scaling, true) == true ? default_node_pool.value.max_count : null
      vnet_subnet_id      = lookup(default_node_pool.value, "subnet_name", null) == null ? null : lookup(var.subnet_ids, default_node_pool.value.subnet_name) # Required for advanced networking
      tags                = local.tags
    }
  }

  dynamic "service_principal" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [true] : []
    content {
      client_id     = var.aks_client_id
      client_secret = var.aks_client_secret
    }
  }

  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : list(coalesce(lookup(each.value, "assign_identity"), false))
    content {
      type = "SystemAssigned"
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = var.log_analytics_workspace_id != null ? true : false
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }

    kube_dashboard {
      enabled = true
    }
  }

  linux_profile {
    admin_username = each.value.admin_username
    ssh_key {
      key_data = lookup(tls_private_key.this, each.key)["public_key_openssh"]
    }
  }

  network_profile {
    network_plugin     = coalesce(each.value.network_plugin, "azure")
    network_policy     = coalesce(each.value.network_policy, "azure")
    docker_bridge_cidr = lookup(each.value, "docker_bridge_cidr", null)
    service_cidr       = lookup(each.value, "service_address_range", null)
    dns_service_ip     = lookup(each.value, "dns_ip", null)
    pod_cidr           = coalesce(each.value.network_plugin, "azure") == "kubenet" ? lookup(each.value, "pod_cidr", null) : null
    load_balancer_sku  = "Standard"
    dynamic "load_balancer_profile" {
      for_each = lookup(each.value, "load_balancer_profile", null) != null ? list(each.value.load_balancer_profile) : []
      content {
        outbound_ports_allocated  = lookup(load_balancer_profile.value, "outbound_ports_allocated", null)
        idle_timeout_in_minutes   = lookup(load_balancer_profile.value, "idle_timeout_in_minutes", null)
        managed_outbound_ip_count = coalesce(lookup(load_balancer_profile.value, "managed_outbound_ip_count"), [])
        outbound_ip_address_ids   = coalesce(lookup(load_balancer_profile.value, "outbound_ip_address_ids"), [])
      }
    }
  }

  dynamic "role_based_access_control" {
    for_each = list(coalesce(each.value.rbac_enabled, false))
    content {
      enabled = role_based_access_control.value
      dynamic "azure_active_directory" {
        for_each = var.ad_enabled != false ? list(var.ad_enabled) : []
        content {
          managed           = false
          client_app_id     = data.azurerm_key_vault_secret.aks_client_app_id[0].value
          server_app_id     = data.azurerm_key_vault_secret.aks_server_app_id[0].value
          server_app_secret = data.azurerm_key_vault_secret.aks_server_app_secret[0].value
        }
      }
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = lookup(each.value, "auto_scaler_profile", null) != null ? list(each.value.auto_scaler_profile) : []
    content {
      balance_similar_node_groups      = lookup(auto_scaler_profile.value, "balance_similar_node_groups", null)
      max_graceful_termination_sec     = lookup(auto_scaler_profile.value, "max_graceful_termination_sec", null)
      scale_down_delay_after_add       = lookup(auto_scaler_profile.value, "scale_down_delay_after_add", null)
      scale_down_delay_after_delete    = lookup(auto_scaler_profile.value, "scale_down_delay_after_delete", null)
      scale_down_delay_after_failure   = lookup(auto_scaler_profile.value, "scale_down_delay_after_failure", null)
      scan_interval                    = lookup(auto_scaler_profile.value, "scan_interval", null)
      scale_down_unneeded              = lookup(auto_scaler_profile.value, "scale_down_unneeded", null)
      scale_down_unready               = lookup(auto_scaler_profile.value, "scale_down_unready", null)
      scale_down_utilization_threshold = lookup(auto_scaler_profile.value, "scale_down_utilization_threshold", null)
    }
  }

  tags = local.tags

  depends_on = [azurerm_disk_encryption_set.this, azurerm_key_vault_access_policy.cmk]
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each              = var.aks_extra_node_pools
  name                  = each.value["name"]
  vm_size               = each.value["vm_size"]
  kubernetes_cluster_id = lookup(azurerm_kubernetes_cluster.this, each.value["aks_key"])["id"]
  availability_zones    = lookup(each.value, "availability_zones", null)
  enable_auto_scaling   = coalesce(each.value.enable_auto_scaling, true)
  max_pods              = lookup(each.value, "max_pods", null)
  os_disk_size_gb       = lookup(each.value, "os_disk_size_gb", null)
  mode                  = lookup(each.value, "mode", null)
  node_count            = coalesce(each.value.enable_auto_scaling, true) == true ? lookup(each.value, "node_count", null) : each.value.node_count
  min_count             = coalesce(each.value.enable_auto_scaling, true) == true ? each.value.min_count : null
  max_count             = coalesce(each.value.enable_auto_scaling, true) == true ? each.value.max_count : null
  vnet_subnet_id        = lookup(each.value, "subnet_name", null) == null ? null : lookup(var.subnet_ids, each.value.subnet_name) # Required for advanced networking
  tags                  = local.tags
}

# -
# - Create Key Vault Accesss Policy for AKS MSI
# -
locals {
  msi_enabled_aks_clusters = [
    for aks_k, aks_v in var.aks_clusters :
    aks_v if coalesce(lookup(aks_v, "assign_identity"), false) == true
  ]

  aks_principal_ids = flatten([
    for x in azurerm_kubernetes_cluster.this :
    [
      for y in x.identity :
      y.principal_id if y.principal_id != ""
    ] if length(keys(azurerm_kubernetes_cluster.this)) > 0
  ])

  key_permissions         = ["get", "list", "update", "create", "delete", "purge"]
  secret_permissions      = ["get", "list", "set", "delete", "purge"]
  certificate_permissions = ["get", "list", "update", "create", "delete", "purge", "import"]
  storage_permissions     = ["delete", "get", "list", "purge", "set", "update"]
}

resource "azurerm_key_vault_access_policy" "this" {
  count        = length(local.msi_enabled_aks_clusters) > 0 ? length(local.aks_principal_ids) : 0
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = element(local.aks_principal_ids, count.index)

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_kubernetes_cluster.this]
}

#####################################################
# AKS Disk Encryption Set for CMK
#####################################################
locals {
  disk_encryption_set_enabled_aks = {
    for aks_k, aks_v in var.aks_clusters :
    aks_k => aks_v if coalesce(lookup(aks_v, "cmk_enabled"), false) == true
  }
}

# -
# - Generate Key for AKS Disk Encryption Set
# -
resource "null_resource" "dependency_modules" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}
resource "azurerm_key_vault_key" "this" {
  for_each     = local.disk_encryption_set_enabled_aks
  name         = each.value.name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt", "encrypt", "sign",
    "unwrapKey", "verify", "wrapKey"
  ]

  depends_on = [null_resource.dependency_modules]
}

# -
# - Create Disk Encryption Set for AKS
# -
resource "azurerm_disk_encryption_set" "this" {
  for_each            = local.disk_encryption_set_enabled_aks
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  key_vault_key_id    = lookup(azurerm_key_vault_key.this, each.key)["id"]

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# -
# - Adding Access Policies for Disk Encryption Set MSI
# -
resource "azurerm_key_vault_access_policy" "cmk" {
  for_each     = local.disk_encryption_set_enabled_aks
  key_vault_id = var.key_vault_id

  tenant_id = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.tenant_id
  object_id = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.principal_id

  key_permissions    = ["get", "decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  secret_permissions = ["get"]
}

resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  for_each                   = var.aks_clusters
  name                       = "loganalytics-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.this[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "kube-audit"
    enabled  = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "kube-apiserver"
    enabled  = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "kube-controller-manager"
    enabled  = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "kube-scheduler"
    enabled  = true
    retention_policy {
      enabled = true
    }
  }
  log {
    category = "cluster-autoscaler"
    enabled  = true
    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}
