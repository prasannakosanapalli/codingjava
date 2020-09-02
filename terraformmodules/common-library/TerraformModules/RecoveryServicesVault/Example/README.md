# Create Recovery Services Vaults in Azure

This Module allows you to create and manage one or multiple Recovery Services Vaults in Microsoft Azure.

## Features

This module will:

- Create one or multiple Recovery Services Vaults in Microsoft Azure.
- Create one or multiple Azure VM Backup Policy.

## Usage

```hcl
module "RecoveryServicesVault" {
  source                   = "../../common-library/TerraformModules/RecoveryServicesVault"
  resource_group_name      = module.BaseInfrastructure.resource_group_name
  rv_additional_tags       = var.additional_tags
  recovery_services_vaults = var.recovery_services_vaults
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

    Description: Specifies the name of the resource group in which to create the Recovery Services Vault.

#### recovery_services_vaults `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Recovery Services Vaults.

| Attribute           | Data Type  | Field Type | Description                                                                                           | Allowed Values |
| :------------------ | :--------: | :--------: | :---------------------------------------------------------------------------------------------------- | :------------- |
| name                |   string   |  Required  | Specifies the name of the Recovery Services Vault. Changing this forces a new resource to be created. |                |
| policy_name         |   string   |  Required  | Specifies the name of the Backup Policy. Changing this forces a new resource to be created.           |                |
| sku                 |   string   |  Required  | Sets the vault's SKU.                                                                                 | Standard, RS0  |
| soft_delete_enabled |    bool    |  Optional  | Is soft delete enable for this Vault ? Defaults to true.                                              | true, false    |
| backup_settings     | object({}) |  Required  | Configures the Policy backup frequency, times & days as documented in the backup block below          |                |
| retention_settings  | object({}) |  Required  | Configures the policy retention settings as documented in the retention_settings block below          |                |

#### backup_settings

| Attribute | Data Type | Field Type | Description                                            | Allowed Values                                                   |
| :-------- | :-------: | :--------: | :----------------------------------------------------- | :--------------------------------------------------------------- |
| frequency |  string   |  Required  | Sets the backup frequency                              | Daily or Weekly                                                  |
| time      |  string   |  Required  | The time of day to perform the backup in 24hour format |                                                                  |
| weekdays  |  string   |  Optional  | The days of the week to perform backups on             | Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday |

#### retention_settings

| Attribute | Data Type | Field Type | Description                                                                                                                                             | Allowed Values                                                                                                                                                                                    |
| :-------- | :-------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| daily     |  number   |  Required  | The number of daily backups to keep                                                                                                                     | between 1 and 9999                                                                                                                                                                                |
| weekly    |  string   |  Optional  | The number of daily backups to keep and weekday backups to retain                                                                                       | "<1 to 9999>:<Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday>"                                                                                                                          |
| monthly   |  string   |  Optional  | The number of daily backups to keep, weekday backups to retain and weeks of the month to retain backups of                                              | "<1 to 9999>:<Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday>:<First,Second,Third,Fourth,Last>"                                                                                         |
| yearly    |  string   |  Optional  | The number of daily backups to keep, weekday backups to retain, weeks of the month to retain backups of and The months of the year to retain backups of | "<1 to 9999>:<Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday>:<First,Second,Third,Fourth,Last>:<January,February,March,April,May,June,July,Augest,September,October,November,December>" |

### **Optional Parameters**

#### rv_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Recovery Services Vault resources tags, in addition to the resource group tags.

    Default: {}

## Outputs

#### map_recovery_vaults

    Description: The Map of Recovery Services Vault and Azure VM Backup Policy Resources.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_recovery_services_vault](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_vault.html) <br />
[azurerm_backup_policy_vm](https://www.terraform.io/docs/providers/azurerm/r/backup_policy_vm.html)
