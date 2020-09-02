# Create Application Insights in Azure

This Module allows you to create and manage one or multiple Application Insights in Microsoft Azure.

## Features

This module will:

- Create one or multiple Application Insights in Microsoft Azure.

## Usage

```hcl
module "ApplicationInsights" {
  source                       = "../../common-library/TerraformModules/ApplicationInsights"
  resource_group_name          = module.BaseInfrastructure.resource_group_name
  application_insights         = var.application_insights
  app_insights_additional_tags = var.additional_tags
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

    Description: Specifies the name of the resource group in which to create the Application Insights.

#### application_insights `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Application Insights.

| Attribute                             | Data Type | Field Type | Description                                                                                                                                                                                                                                      | Allowed Values                                             |
| :------------------------------------ | :-------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------- |
| name                                  |  string   |  Required  | Specifies the name of the Application Insights component. Changing this forces a new resource to be created.                                                                                                                                     |                                                            |
| application_type                      |  string   |  Required  | Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET | ios, java, MobileCenter, Node.JS, phone, store, web, other |
| retention_in_days                     |  number   |  Optional  | Specifies the retention period in days.                                                                                                                                                                                                          | 30, 60, 90, 120, 180, 270, 365, 550 or 730                 |
| daily_data_cap_in_gb                  |  number   |  Optional  | Specifies the Application Insights component daily data volume cap in GB.                                                                                                                                                                        |                                                            |
| daily_data_cap_notifications_disabled |   bool    |  Optional  | Specifies if a notification email will be send when the daily data volume cap is met.                                                                                                                                                            | true, false                                                |
| sampling_percentage                   |  number   |  Optional  | Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry.                                                                                                                   |                                                            |
| disable_ip_masking                    |   bool    |  Optional  | By default the real client ip is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client ip. Defaults to false.                                                                                              | true, false                                                |

### **Optional Parameters**

#### app_insights_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Application Insights resources tags, in addition to the resource group tags.

    Default: {}

## Outputs

#### instrumentation_key_map

    Description: The Map of Instrumentation Key for this Application Insights components.

#### app_id

    Description: The Map of App ID associated with this Application Insights components.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_application_insights](http://terraform.io/docs/providers/azurerm/r/application_insights.html)
