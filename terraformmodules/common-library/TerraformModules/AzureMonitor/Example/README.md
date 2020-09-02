# Create Azure Monitors in Azure

This Module allows you to create and manage one or multiple Azure Monitors in Microsoft Azure.

## Features

This module will:

- Create one or multiple Azurerm Monitor Action Groups within Azure Monitor.
- Create one or multiple Azurerm Monitor Metric Alerts within Azure Monitor.
- Create one or multiple Azurerm Monitor Log Profiles within Azure Monitor.
- Create one or multiple Scheduled Query Rules resource within Azure Monitor.

## Usage

```hcl
module "AzureMonitor" {
  source                        = "../../common-library/TerraformModules/AzureMonitor"
  resource_group_name           = module.BaseInfrastructure.resource_group_name
  storage_account_ids_map       = module.BaseInfrastructure.sa_ids_map
  resource_ids                  = module.Virtualmachine.linux_vm_id_map
  law_id_map                    = module.BaseInfrastructure.law_id_map
  action_groups                 = var.action_groups
  metric_alerts                 = var.metric_alerts
  log_profiles                  = var.log_profiles
  query_rules_alerts            = var.query_rules_alerts
  azure_monitor_additional_tags = var.additional_tags
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the resource group module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the resource group module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the resource group module.

## Best practices for variable declaration/defination

- All names of the Resources should be defined as per AT&T standard naming conventions.

- While declaring variables with data type 'map(object)' or 'object; or 'list(object)', It's mandatory to define all the attributes in object. If you don't want to set any attribute then define its value as null or empty list([]) or empty map({}) as per the object data type.

- Please make sure all the Required parameters are set. Refer below section to understand the required and optional input values when using this module.

- Please verify that the values provided to the variables are in comfort with the allowed values for that variable. Refer below section to understand the allowed values for each variable when using this module.

## Inputs

### **Required Parameters**

These variables must be set in the `module` block when using this module.

#### resource_group_name `string`

    Description: Specifies the name of the resource group in which to create the Azure Monitor.

#### action_groups `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Azure Monitor Action Groups.

    Default: {}

| Attribute                |    Data Type     | Field Type | Description                                                                                                                                        | Allowed Values |
| :----------------------- | :--------------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                     |      string      |  Required  | Specifies the name of the Action Group. Changing this forces a new resource to be created.                                                         |                |
| short_name               |      string      |  Required  | Specifies the short name of the action group. This will be used in SMS messages.                                                                   |                |
| enabled                  |       bool       |  Optional  | Whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications. Defaults to true. | true , false   |
| arm_role_receivers       | list(object({})) |  Optional  | Specifies One or more **_arm_role_receiver_** blocks as defined below.                                                                             |                |
| azure_app_push_receivers | list(object({})) |  Optional  | One or more **_azure_app_push_receiver_** blocks as defined below.                                                                                 |                |
| azure_function_receivers | list(object({})) |  Optional  | One or more **_azure_function_receiver_** blocks as defined below.                                                                                 |                |
| email_receivers          | list(object({})) |  Optional  | One or more **_email_receiver_** blocks as defined below.                                                                                          |                |
| logic_app_receivers      | list(object({})) |  Optional  | One or more **_logic_app_receiver_** blocks as defined below.                                                                                      |                |
| sms_receivers            | list(object({})) |  Optional  | One or more **_sms_receiver_** blocks as defined below.                                                                                            |                |
| voice_receivers          | list(object({})) |  Optional  | One or more **_voice_receiver_** blocks as defined below.                                                                                          |                |
| webhook_receivers        | list(object({})) |  Optional  | One or more **_webhook_receiver_** blocks as defined below.                                                                                        |                |

#### arm_role_receiver

| Attribute               | Data Type | Field Type | Description                                  | Allowed Values |
| :---------------------- | :-------: | :--------: | :------------------------------------------- | :------------- |
| name                    |  string   |  Required  | The name of the ARM role receiver.           |                |
| role_id                 |  string   |  Required  | The arm role id.                             |                |
| use_common_alert_schema |   bool    |  Optional  | Enables or disables the common alert schema. | true , false   |

#### azure_app_push_receiver

| Attribute     | Data Type | Field Type | Description                                                                                                      | Allowed Values |
| :------------ | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------------- | :------------- |
| name          |  string   |  Required  | The name of the Azure app push receiver.                                                                         |                |
| email_address |  string   |  Required  | The email address of the user signed into the mobile app who will receive push notifications from this receiver. |                |

#### azure_function_receiver

| Attribute                | Data Type | Field Type | Description                                      | Allowed Values |
| :----------------------- | :-------: | :--------: | :----------------------------------------------- | :------------- |
| name                     |  string   |  Required  | The name of the Azure Function receiver.         |                |
| function_app_resource_id |  string   |  Required  | The Azure resource ID of the function app.       |                |
| function_name            |  string   |  Required  | The function name in the function app.           |                |
| http_trigger_url         |  string   |  Required  | The http trigger url where http request sent to. |                |
| use_common_alert_schema  |   bool    |  Optional  | Enables or disables the common alert schema.     | true , false   |

#### email_receiver

| Attribute               | Data Type | Field Type | Description                                                                                                          | Allowed Values |
| :---------------------- | :-------: | :--------: | :------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                    |  string   |  Required  | The name of the email receiver. Names must be unique (case-insensitive) across all receivers within an action group. |                |
| email_address           |  string   |  Required  | The email address of this receiver.                                                                                  |                |
| use_common_alert_schema |   bool    |  Optional  | Enables or disables the common alert schema.                                                                         | true , false   |

#### logic_app_receiver

| Attribute               | Data Type | Field Type | Description                                  | Allowed Values |
| :---------------------- | :-------: | :--------: | :------------------------------------------- | :------------- |
| name                    |  string   |  Required  | The name of the logic app receiver.          |                |
| resource_id             |  string   |  Required  | The Azure resource ID of the logic app.      |                |
| callback_url            |  string   |  Required  | The callback url where http request sent to. |                |
| use_common_alert_schema |   bool    |  Optional  | Enables or disables the common alert schema. | true , false   |

#### sms_receiver

| Attribute    | Data Type | Field Type | Description                                                                                                        | Allowed Values |
| :----------- | :-------: | :--------: | :----------------------------------------------------------------------------------------------------------------- | :------------- |
| name         |  string   |  Required  | The name of the SMS receiver. Names must be unique (case-insensitive) across all receivers within an action group. |                |
| country_code |  string   |  Required  | The country code of the SMS receiver.                                                                              |                |
| phone_number |  string   |  Required  | The phone number of the SMS receiver.                                                                              |                |

#### voice_receiver

| Attribute    | Data Type | Field Type | Description                             | Allowed Values |
| :----------- | :-------: | :--------: | :-------------------------------------- | :------------- |
| name         |  string   |  Required  | The name of the voice receiver.         |                |
| country_code |  string   |  Required  | The country code of the voice receiver. |                |
| phone_number |  string   |  Required  | The phone number of the voice receiver. |                |

#### webhook_receiver

| Attribute               | Data Type | Field Type | Description                                                                                                            | Allowed Values |
| :---------------------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                    |  string   |  Required  | The name of the webhook receiver. Names must be unique (case-insensitive) across all receivers within an action group. |                |
| service_uri             |  string   |  Required  | The URI where webhooks should be sent.                                                                                 |                |
| use_common_alert_schema |   bool    |  Optional  | Enables or disables the common alert schema.                                                                           | true , false   |

### **Optional Parameters**

#### azure_monitor_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Azure Monitor resources tags, in addition to the resource group tags.

    Default: {}

#### storage_account_ids_map `map(string)`

    Description: Specifies the Map of Storage Account Id's.

    Default: {}

#### resource_ids `map(string)`

    Description: Specifies the Map of resource id's at which the metric criteria should be applied.

    Default: {}

#### law_id_map `map(string)`

    Description: Specifies the Map of Log Analytics Workspace Id's.

    Default: {}

#### metric_alerts `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Azure Monitor Metric Alerts.

    Default: {}

| Attribute          |    Data Type     | Field Type | Description                                                                                                                                                      | Allowed Values                                    |
| :----------------- | :--------------: | :--------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------ |
| name               |      string      |  Required  | The name of the Metric Alert. Changing this forces a new resource to be created.                                                                                 |                                                   |
| resource_names     |   list(string)   |  Required  | A set of strings of resource names at which the metric criteria should be applied.                                                                               |                                                   |
| description        |      string      |  Optional  | The description of this Metric Alert.                                                                                                                            |                                                   |
| enabled            |       bool       |  Optional  | Should this Metric Alert be enabled? Defaults to true.                                                                                                           | true , false                                      |
| auto_mitigate      |       bool       |  Optional  | Should the alerts in this Metric Alert be auto resolved? Defaults to true.                                                                                       |                                                   |
| frequency          |      string      |  Optional  | The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format. Defaults to PT1M.                                                        | PT1M, PT5M, PT15M, PT30M , PT1H                   |
| severity           |      number      |  Optional  | The severity of this Metric Alert. Defaults to 3.                                                                                                                | 0, 1, 2, 3 , 4                                    |
| window_size        |      string      |  Optional  | The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Defaults to PT5M. | PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H , P1D |
| criterias          | list(object({})) |  Required  | One or more **_criteria_** blocks as defined below.                                                                                                              |                                                   |
| action_group_names |   list(string)   |  Optional  | The name of the Action Group reference resource which can be sourced from **_action_groups_** variable block.                                                    |                                                   |

#### criteria

| Attribute        |    Data Type     | Field Type | Description                                            | Allowed Values                                                                 |
| :--------------- | :--------------: | :--------: | :----------------------------------------------------- | :----------------------------------------------------------------------------- |
| metric_namespace |      string      |  Required  | One of the metric namespaces to be monitored.          |                                                                                |
| metric_name      |      string      |  Required  | One of the metric names to be monitored.               |                                                                                |
| aggregation      |      string      |  Required  | The statistic that runs over the metric values.        | Average, Count, Minimum, Maximum , Total.                                      |
| operator         |      string      |  Required  | The criteria operator.                                 | Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan , LessThanOrEqual |
| threshold        |      number      |  Required  | The criteria threshold value that activates the alert. |                                                                                |
| dimensions       | list(object({})) |  Optional  | One or more **_dimension_** blocks as defined below.   |                                                                                |

#### dimension

| Attribute |  Data Type   | Field Type | Description                   | Allowed Values    |
| :-------- | :----------: | :--------: | :---------------------------- | :---------------- |
| name      |    string    |  Required  | One of the dimension names.   |                   |
| operator  |    string    |  Required  | The dimension operator.       | Include , Exclude |  |
| values    | list(string) |  Required  | The list of dimension values. |                   |

#### log_profiles `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Azure Monitor Log Profiles.

    Default: {}

| Attribute                        |  Data Type   | Field Type | Description                                                                     | Allowed Values |
| :------------------------------- | :----------: | :--------: | :------------------------------------------------------------------------------ | :------------- |
| name                             |    string    |  Required  | The name of the Log Profile. Changing this forces a new resource to be created. |                |
| locations                        | list(string) |  Required  | List of regions for which Activity Log events are stored or streamed.           |                |
| diagnostics_storage_account_name |    string    |  Required  | The resource name of the storage account in which the Activity Log is stored.   |                |
| retention_days                   |    number    |  Optional  | The number of days for the retention policy. Defaults to 0.                     |                |

#### query_rules_alerts `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Azure Monitor Scheduled Query Rule Alerts.

    Default: {}

| Attribute          |  Data Type   | Field Type | Description                                                                                                                  | Allowed Values                              |
| :----------------- | :----------: | :--------: | :--------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------ |
| name               |    string    |  Required  | The name of the scheduled query rule. Changing this forces a new resource to be created.                                     |                                             |
| law_name           |    string    |  Required  | The Log Analytics Workspace resource Name over which log search query is to be run.                                          |                                             |
| frequency          |    number    |  Required  | Frequency (in minutes) at which rule condition should be evaluated.                                                          | between 5 and 1440 (inclusive)              |
| query              |    string    |  Required  | Log search query.                                                                                                            | Sample Format: **_<<-EOT <log_query> EOT_** |
| time_window        |    number    |  Required  | Time window for which data needs to be fetched for query (must be greater than or equal to frequency).                       | between 5 and 2880 (inclusive)              |
| action_group_names | list(string) |  Required  | List of action group reference resource names which can be sourced from **_action_groups_** variable block.                  |                                             |
| email_subject      |    string    |  Optional  | Custom subject override for all email ids in Azure action group.                                                             |                                             |
| description        |    string    |  Optional  | The description of the scheduled query rule.                                                                                 |                                             |
| enabled            |     bool     |  Optional  | Whether this scheduled query rule is enabled. Default is true.                                                               | true, false                                 |
| severity           |    number    |  Optional  | Severity of the alert.                                                                                                       | 0, 1, 2, 3, or 4                            |
| throttling         |    number    |  Optional  | Time (in minutes) for which Alerts should be throttled or suppressed.                                                        | between 0 and 10000 (inclusive)             |
| trigger            |  object({})  |  Required  | Specifies the condition that results in the alert rule being run which is mentioned in **_trigger_** block as defined below. |

#### trigger

| Attribute      | Data Type  | Field Type | Description                                                                             | Allowed Values                       |
| :------------- | :--------: | :--------: | :-------------------------------------------------------------------------------------- | :----------------------------------- |
| operator       |   string   |  Required  | Evaluation operation for rule.                                                          | 'Equal', 'GreaterThan' or 'LessThan' |
| threshold      |   number   |  Required  | Result or count threshold based on which rule should be triggered.                      | between 0 and 10000 inclusive        |
| metric_trigger | object({}) |  Optional  | A **_metric_trigger_** block as defined below. Trigger condition for metric query rule. |                                      |

#### metric_trigger

| Attribute           | Data Type | Field Type | Description                                  | Allowed Values                       |
| :------------------ | :-------: | :--------: | :------------------------------------------- | :----------------------------------- |
| metric_column       |  string   |  Required  | Evaluation of metric on a particular column. |                                      |
| metric_trigger_type |  string   |  Required  | Metric Trigger Type.                         | 'Consecutive' or 'Total'             |
| operator            |  string   |  Required  | Evaluation operation for rule.               | 'Equal', 'GreaterThan' or 'LessThan' |
| threshold           |  number   |  Required  | The threshold of the metric trigger.         | between 0 and 10000 inclusive        |

## Outputs

#### action_group_ids

    Description: Specifies the list of Azure Monitor Actin Group Id's.

#### action_group_ids_map

    Description: Specifies the Map of Azure Monitor Actin Group Id's.

#### metric_alert_ids

    Description: Specifies the list of Azure Monitor Metric Alert Id's.

#### metric_alert_ids_map

    Description: Specifies the Map of Azure Monitor Metric Alert Id's.

#### log_profile_ids

    Description: Specifies the list of Azure Monitor Log Profile Id's.

#### log_profile_ids_map

    Description: Specifies the Map of Azure Monitor Log Profile Id's.

#### query_rule_alert_ids

    Description: Specifies the list of Azure Monitor Scheduled Query Rule Alert Id's.

#### query_rule_alert_ids_map

    Description: Specifies the Map of Azure Monitor Scheduled Query Rule Alert Id's.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_monitor_action_group](https://www.terraform.io/docs/providers/azurerm/r/monitor_action_group.html) <br />
[azurerm_monitor_metric_alert](https://www.terraform.io/docs/providers/azurerm/r/monitor_metric_alert.html) <br />
[azurerm_monitor_log_profile](https://www.terraform.io/docs/providers/azurerm/r/monitor_log_profile.html) <br />
[azurerm_monitor_scheduled_query_rules_alert](https://www.terraform.io/docs/providers/azurerm/r/monitor_scheduled_query_rules_alert.html#example-usage)
