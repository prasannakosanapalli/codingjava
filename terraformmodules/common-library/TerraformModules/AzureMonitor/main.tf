data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.azure_monitor_additional_tags, data.azurerm_resource_group.this.tags)

  action_group_ids_map = {
    for x in azurerm_monitor_action_group.this : x.name => x.id
  }

  metric_alerts_list = flatten([
    for ma_k, ma_v in var.metric_alerts :
    [
      for resource_name in ma_v.resource_names :
      {
        key                = "${ma_k}_${resource_name}"
        name               = "${ma_v.name}-${resource_name}",
        scopes             = [lookup(var.resource_ids, resource_name, null)],
        enabled            = ma_v.enabled,
        description        = ma_v.description,
        auto_mitigate      = ma_v.auto_mitigate,
        frequency          = ma_v.frequency,
        severity           = ma_v.severity,
        window_size        = ma_v.window_size,
        criterias          = ma_v.criterias,
        action_group_names = ma_v.action_group_names
      }
    ]
  ])
  metric_alerts_map = {
    for ma in local.metric_alerts_list :
    ma.key => ma
  }
}

# -
# - Manages an Action Group within Azure Monitor 
# -
resource "azurerm_monitor_action_group" "this" {
  for_each            = var.action_groups
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  short_name          = each.value["short_name"]
  enabled             = lookup(each.value, "enabled", null)

  dynamic "arm_role_receiver" {
    for_each = coalesce(lookup(each.value, "arm_role_receivers"), [])
    content {
      name                    = arm_role_receiver.value.name
      role_id                 = arm_role_receiver.value.role_id
      use_common_alert_schema = coalesce(lookup(arm_role_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "azure_app_push_receiver" {
    for_each = coalesce(lookup(each.value, "azure_app_push_receivers"), [])
    content {
      name          = azure_app_push_receiver.value.name
      email_address = azure_app_push_receiver.value.email_address
    }
  }

  dynamic "azure_function_receiver" {
    for_each = coalesce(lookup(each.value, "azure_function_receivers"), [])
    content {
      name                     = azure_function_receiver.value.name
      function_app_resource_id = azure_function_receiver.value.function_app_resource_id
      function_name            = azure_function_receiver.value.function_name
      http_trigger_url         = azure_function_receiver.value.http_trigger_url
      use_common_alert_schema  = coalesce(lookup(azure_function_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "logic_app_receiver" {
    for_each = coalesce(lookup(each.value, "logic_app_receivers"), [])
    content {
      name                    = logic_app_receiver.value.name
      resource_id             = logic_app_receiver.value.resource_id
      callback_url            = logic_app_receiver.value.callback_url
      use_common_alert_schema = coalesce(lookup(logic_app_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "email_receiver" {
    for_each = coalesce(lookup(each.value, "email_receivers"), [])
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = coalesce(lookup(email_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "sms_receiver" {
    for_each = coalesce(lookup(each.value, "sms_receivers"), [])
    content {
      name         = sms_receiver.value.name
      country_code = sms_receiver.value.country_code
      phone_number = sms_receiver.value.phone_number
    }
  }

  dynamic "voice_receiver" {
    for_each = coalesce(lookup(each.value, "voice_receivers"), [])
    content {
      name         = voice_receiver.value.name
      country_code = voice_receiver.value.country_code
      phone_number = voice_receiver.value.phone_number
    }
  }

  dynamic "webhook_receiver" {
    for_each = coalesce(lookup(each.value, "webhook_receivers"), [])
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = coalesce(lookup(webhook_receiver.value, "use_common_alert_schema"), true)
    }
  }

  tags = local.tags
}

# -
# - Manages a Metric Alert within Azure Monitor
# -
resource "azurerm_monitor_metric_alert" "this" {
  for_each            = local.metric_alerts_map
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  scopes              = each.value["scopes"]

  description   = lookup(each.value, "description", null)
  enabled       = lookup(each.value, "enabled", null)
  auto_mitigate = lookup(each.value, "auto_mitigate", null)
  frequency     = lookup(each.value, "frequency", null)
  severity      = lookup(each.value, "severity", null)
  window_size   = lookup(each.value, "window_size", null)

  dynamic "criteria" {
    for_each = coalesce(lookup(each.value, "criterias"), [])
    content {
      metric_namespace = lookup(criteria.value, "metric_namespace", null)
      metric_name      = lookup(criteria.value, "metric_name", null)
      aggregation      = lookup(criteria.value, "aggregation", null)
      operator         = lookup(criteria.value, "operator", null)
      threshold        = lookup(criteria.value, "threshold", null)
      dynamic "dimension" {
        for_each = coalesce(lookup(criteria.value, "dimensions", []), [])
        content {
          name     = lookup(dimension.value, "name", null)
          operator = lookup(dimension.value, "operator", null)
          values   = lookup(dimension.value, "values", null)
        }
      }
    }
  }

  dynamic "action" {
    for_each = coalesce(lookup(each.value, "action_group_names"), [])
    content {
      action_group_id = lookup(local.action_group_ids_map, action.value)
    }
  }

  tags = local.tags

  depends_on = [azurerm_monitor_action_group.this]
}

# -
# - Manages a Log Profile. A Log Profile configures how Activity Logs are exported
# -
resource "azurerm_monitor_log_profile" "this" {
  for_each   = var.log_profiles
  name       = each.value["name"]
  categories = ["Action", "Delete", "Write"]
  locations  = each.value["locations"]

  storage_account_id = lookup(var.storage_account_ids_map, each.value["diagnostics_storage_account_name"])

  retention_policy {
    enabled = true
    days    = lookup(each.value, "retention_days", null)
  }
}

# -
# - Manages an AlertingAction Scheduled Query Rules resource within Azure Monitor.
# -
resource "azurerm_monitor_scheduled_query_rules_alert" "this" {
  for_each            = var.query_rules_alerts
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  data_source_id      = lookup(var.law_id_map, each.value["law_name"], null)
  frequency           = each.value["frequency"]
  query               = <<-QUERY
    ${each.value["query"]}
  QUERY
  time_window         = each.value["time_window"]

  dynamic "trigger" {
    for_each = lookup(each.value, "trigger", null) != null ? list(lookup(each.value, "trigger")) : []
    content {
      operator  = lookup(trigger.value, "operator", null)
      threshold = lookup(trigger.value, "threshold", null)
      dynamic "metric_trigger" {
        for_each = lookup(trigger.value, "metric_trigger", null) != null ? list(lookup(trigger.value, "metric_trigger")) : []
        content {
          metric_column       = lookup(metric_trigger.value, "metric_column", null)
          metric_trigger_type = lookup(metric_trigger.value, "metric_trigger_type", null)
          operator            = lookup(metric_trigger.value, "operator", null)
          threshold           = lookup(metric_trigger.value, "threshold", null)
        }
      }
    }
  }

  dynamic "action" {
    for_each = lookup(each.value, "action_group_names", null) != null ? [lookup(each.value, "action_group_names")] : []
    content {
      action_group = [
        for action_group_name in action.value :
        lookup(local.action_group_ids_map, action_group_name)
      ]
      email_subject = lookup(each.value, "email_subject", null)
    }
  }

  authorized_resource_ids = list(lookup(var.law_id_map, each.value["law_name"], null))
  description             = lookup(each.value, "description", null)
  enabled                 = coalesce(lookup(each.value, "enabled"), true)
  severity                = lookup(each.value, "severity", null)
  throttling              = lookup(each.value, "throttling", null)

  depends_on = [azurerm_monitor_action_group.this]
}

# -
# - Manages a LogToMetricAction Scheduled Query Rules resource within Azure Monitor.
# -
# resource "azurerm_scheduled_query_rule_log" "this" {
#   for_each            = var.query_rules_logs
#   name                = each.value["name"]
#   resource_group_name = data.azurerm_resource_group.example.name
#   # location            = data.azurerm_resource_group.example.location
#   data_source_id = lookup(var.law_id_map, each.value["law_name"], null)
#   description    = lookup(each.value, "description", null)
#   enabled        = coalesce(lookup(each.value, "enabled"), true)

#   dynamic "criteria" {
#     for_each = lookup(each.value, "criteria", null) != null ? list(lookup(each.value, "criteria")) : []
#     content {
#       metric_name = lookup(criteria.value, "metric_name", null)
#       dynamic "dimensions" {
#         for_each = lookup(criteria.value, "dimensions", null) != null ? list(lookup(criteria.value, "dimensions")) : []
#         content {
#           name     = lookup(dimensions.value, "name", null)
#           operator = lookup(dimensions.value, "operator", null)
#           values   = lookup(dimensions.value, "values", null)
#         }
#       }
#     }
#   }
# }
