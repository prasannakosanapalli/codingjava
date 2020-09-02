resource_group_name = "resource_group_name" # "<resource_group_name>"

action_groups = {
  ag1 = {
    name                     = "action_group_name"
    short_name               = "action_group_name_alias"
    enabled                  = null
    arm_role_receivers       = null
    azure_app_push_receivers = null
    azure_function_receivers = null
    email_receivers          = null
    logic_app_receivers      = null
    voice_receivers          = null
    webhook_receivers        = null
    sms_receivers = [{
      name         = "oncallmsg"
      country_code = "1"
      phone_number = "1231231234"
    }]
  }
}

metric_alerts = {
  ma1 = {
    name               = "metric_alert_name"
    resource_names     = ["reource_name_to_enable_alert"]
    enabled            = null
    description        = "Action will be triggered when Average Percentage CPU is greater than 70."
    auto_mitigate      = null
    frequency          = null
    severity           = null
    window_size        = null
    action_group_names = ["action_group_name"]
    criterias = [{
      metric_namespace = "Microsoft.Compute/virtualMachines"
      metric_name      = "Percentage CPU"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 50
      dimensions       = null
    }]
  }
}

log_profiles = {
  lp1 = {
    name                             = "default"
    locations                        = ["westus", "global"]
    retention_days                   = 7
    diagnostics_storage_account_name = "diagnostics_storage_account_name"
  }
}

query_rules_alerts = {
  qra1 = {
    name               = "cpu-utilization-alert"
    law_name           = "log_analytics_workspace_name"
    frequency          = 5
    time_window        = 30
    action_group_names = ["action_group_name"]
    email_subject      = null
    description        = "CPU Utilization"
    enabled            = true
    severity           = 1
    throttling         = 5
    query              = <<-EOT
        InsightsMetrics
            | where Origin == "vm.azm.ms" 
            | where Namespace == "Processor" and Name == "UtilizationPercentage" 
            | summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId
      EOT
    trigger = {
      operator  = "GreaterThan"
      threshold = 3
      metric_trigger = {
        operator            = "GreaterThan"
        threshold           = 1
        metric_trigger_type = "Total"
        metric_column       = "operation_Name"
      }
    }
  }
}


additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
