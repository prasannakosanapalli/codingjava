data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.app_service_additional_tags, data.azurerm_resource_group.this.tags)
}

data "azurerm_app_service_plan" "this" {
  for_each            = var.existing_app_service_plans
  name                = each.value["name"]
  resource_group_name = lookup(each.value, "resource_group_name", data.azurerm_resource_group.this.name)
}

# -
# - App Service Plan
# -
resource "azurerm_app_service_plan" "this" {
  for_each            = var.app_service_plans
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  kind                         = coalesce(lookup(each.value, "kind"), "Linux")
  maximum_elastic_worker_count = lookup(each.value, "maximum_elastic_worker_count", null)
  reserved                     = coalesce(lookup(each.value, "kind"), "Linux") == "Linux" ? true : coalesce(lookup(each.value, "reserved"), false)
  per_site_scaling             = lookup(each.value, "per_site_scaling", null)

  sku {
    tier     = each.value["sku_tier"]
    size     = each.value["sku_size"]
    capacity = lookup(each.value, "sku_capacity", null)
  }

  tags = local.tags
}

# -
# - Azure App Service
# -
resource "azurerm_app_service" "this" {
  for_each            = var.app_services
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  app_service_plan_id = lookup(merge(azurerm_app_service_plan.this, data.azurerm_app_service_plan.this), each.value["app_service_plan_key"])["id"]

  app_settings            = lookup(each.value, "app_settings", null)
  client_affinity_enabled = lookup(each.value, "client_affinity_enabled", null)
  client_cert_enabled     = lookup(each.value, "client_cert_enabled", null)
  enabled                 = lookup(each.value, "enabled", null)
  https_only              = coalesce(lookup(each.value, "https_only"), true)

  dynamic "auth_settings" {
    for_each = lookup(each.value, "auth_settings", null) == null ? [] : list(lookup(each.value, "auth_settings"))
    content {
      enabled = coalesce(lookup(auth_settings.value, "enabled"), false)
      #active_directory {}
      additional_login_params        = lookup(auth_settings.value, "additional_login_params", null)
      allowed_external_redirect_urls = lookup(auth_settings.value, "allowed_external_redirect_urls", null)
      default_provider               = lookup(auth_settings.value, "default_provider", null)
      issuer                         = lookup(auth_settings.value, "issuer", null)
      #microsoft {}
      runtime_version               = lookup(auth_settings.value, "runtime_version", null)
      token_refresh_extension_hours = lookup(auth_settings.value, "token_refresh_extension_hours", null)
      token_store_enabled           = lookup(auth_settings.value, "token_store_enabled", null)
      unauthenticated_client_action = lookup(auth_settings.value, "unauthenticated_client_action", null)
    }
  }

  dynamic "storage_account" {
    for_each = coalesce(lookup(each.value, "storage_accounts"), [])
    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = storage_account.value.account_name
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  dynamic "backup" {
    for_each = lookup(each.value, "backup", null) == null ? [] : list(lookup(each.value, "backup"))
    content {
      name                = backup.value.name
      enabled             = backup.value.enabled
      storage_account_url = lookup(backup.value, "storage_account_url", null)
      dynamic "schedule" {
        for_each = lookup(backup.value, "schedule", null) == null ? [] : lookup(backup.value, "schedule")
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = lookup(schedule.value, "frequency_unit", null)
          keep_at_least_one_backup = lookup(schedule.value, "keep_at_least_one_backup", null)
          retention_period_in_days = lookup(schedule.value, "retention_period_in_days", null)
          start_time               = lookup(schedule.value, "start_time", null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = coalesce(lookup(each.value, "connection_strings"), [])
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "site_config" {
    for_each = lookup(each.value, "site_config", null) == null ? [] : list(lookup(each.value, "site_config"))
    content {
      always_on        = lookup(site_config.value, "always_on", null)
      app_command_line = lookup(site_config.value, "app_command_line", null)

      dynamic "ip_restriction" {
        for_each = coalesce(lookup(site_config.value, "ip_restriction"), [])
        content {
          ip_address                = lookup(ip_restriction.value, "ip_address", null)
          virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null)
        }
      }

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", null) == null ? [] : list(lookup(site_config.value, "cors"))
        content {
          allowed_origins     = lookup(cors.value, "allowed_origins", null)
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }

      default_documents        = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version = lookup(site_config.value, "dotnet_framework_version", null)
      ftps_state               = lookup(site_config.value, "ftps_state", null)
      http2_enabled            = lookup(site_config.value, "http2_enabled", null)

      java_version              = lookup(site_config.value, "java_version", null)                                                                                                                                                                                                                                                                                                      #(Optional) The version of Java to use. If specified java_container and java_container_version must also be specified. Possible values are 1.7, 1.8 and 11.
      java_container            = lookup(site_config.value, "java_container", null)                                                                                                                                                                                                                                                                                                    #(Optional) The Java Container to use. If specified java_version and java_container_version must also be specified. Possible values are JETTY and TOMCAT.
      java_container_version    = lookup(site_config.value, "java_container_version", null)                                                                                                                                                                                                                                                                                            #(Optional) The version of the Java Container to use. If specified java_version and java_container must also be specified.
      local_mysql_enabled       = lookup(site_config.value, "local_mysql_enabled", null)                                                                                                                                                                                                                                                                                               #(Optional) Is "MySQL In App" Enabled? This runs a local MySQL instance with your app and shares resources from the App Service plan.NOTE: MySQL In App is not intended for production environments and will not scale beyond a single instance. Instead you may wish to use Azure Database for MySQL.
      linux_fx_version          = lookup(site_config.value, "linux_fx_version", null) == null ? null : lookup(site_config.value, "linux_fx_version_local_file_path", null) == null ? lookup(site_config.value, "linux_fx_version", null) : "${lookup(site_config.value, "linux_fx_version", null)}|${filebase64(lookup(site_config.value, "linux_fx_version_local_file_path", null))}" #(Optional) Linux App Framework and version for the App Service. Possible options are a Docker container (DOCKER|<user/image:tag>), a base-64 encoded Docker Compose file (COMPOSE|${filebase64("compose.yml")}) or a base-64 encoded Kubernetes Manifest (KUBE|${filebase64("kubernetes.yml")}).
      windows_fx_version        = lookup(site_config.value, "windows_fx_version", null)                                                                                                                                                                                                                                                                                                #(Optional) The Windows Docker container image (DOCKER|<user/image:tag>)
      managed_pipeline_mode     = lookup(site_config.value, "managed_pipeline_mode", null)                                                                                                                                                                                                                                                                                             #(Optional) The Managed Pipeline Mode. Possible values are Integrated and Classic. Defaults to Integrated.
      min_tls_version           = lookup(site_config.value, "min_tls_version", null)                                                                                                                                                                                                                                                                                                   #(Optional) The minimum supported TLS version for the app service. Possible values are 1.0, 1.1, and 1.2. Defaults to 1.2 for new app services.
      php_version               = lookup(site_config.value, "php_version", null)                                                                                                                                                                                                                                                                                                       #(Optional) The version of PHP to use in this App Service. Possible values are 5.5, 5.6, 7.0, 7.1 and 7.2.
      python_version            = lookup(site_config.value, "python_version", null)                                                                                                                                                                                                                                                                                                    #(Optional) The version of Python to use in this App Service. Possible values are 2.7 and 3.4.
      remote_debugging_enabled  = lookup(site_config.value, "remote_debugging_enabled", null)                                                                                                                                                                                                                                                                                          #(Optional) Is Remote Debugging Enabled? Defaults to false.
      remote_debugging_version  = lookup(site_config.value, "remote_debugging_version", null)                                                                                                                                                                                                                                                                                          #(Optional) Which version of Visual Studio should the Remote Debugger be compatible with? Possible values are VS2012, VS2013, VS2015 and VS2017.
      scm_type                  = lookup(site_config.value, "scm_type", null)                                                                                                                                                                                                                                                                                                          #(Optional) The type of Source Control enabled for this App Service. Defaults to None. Possible values are: BitbucketGit, BitbucketHg, CodePlexGit, CodePlexHg, Dropbox, ExternalGit, ExternalHg, GitHub, LocalGit, None, OneDrive, Tfs, VSO and VSTSRM
      use_32_bit_worker_process = lookup(site_config.value, "use_32_bit_worker_process", null)                                                                                                                                                                                                                                                                                         #(Optional) Should the App Service run in 32 bit mode, rather than 64 bit mode? NOTE: when using an App Service Plan in the Free or Shared Tiers use_32_bit_worker_process must be set to true.                                                                                                                                                                                                                                                                                         #(Optional) The name of the Virtual Network which this App Service should be attached to.
      websockets_enabled        = lookup(site_config.value, "websockets_enabled", null)                                                                                                                                                                                                                                                                                                #(Optional) Should WebSockets be enabled?
    }
  }

  dynamic "logs" {
    for_each = lookup(each.value, "logs", null) == null ? [] : list(lookup(each.value, "logs"))
    content {
      dynamic "application_logs" {
        for_each = lookup(logs.value, "application_logs", null) == null ? [] : list(lookup(logs.value, "application_logs"))
        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(application_logs.value, "azure_blob_storage", null) == null ? [] : list(lookup(application_logs.value, "azure_blob_storage"))
            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }
        }
      }
      dynamic "http_logs" {
        for_each = lookup(logs.value, "http_logs", null) == null ? [] : list(lookup(logs.value, "http_logs"))
        content {
          dynamic "file_system" {
            for_each = lookup(http_logs.value, "file_system", null) == null ? [] : list(lookup(http_logs.value, "file_system"))
            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
          dynamic "azure_blob_storage" {
            for_each = lookup(http_logs.value, "azure_blob_storage", null) == null ? [] : list(lookup(http_logs.value, "azure_blob_storage"))
            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }
        }
      }
    }
  }

  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : list(coalesce(lookup(each.value, "assign_identity"), false))
    content {
      type = "SystemAssigned"
    }
  }

  tags = local.tags
}