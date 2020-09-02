# Enable NSG flow logs

This Module allows you to enable NSG flow logs

## Features

- Enable NSG flow logs for multiple NSG's

## usage

```hcl
module "nsg-flow-log" {
  source = "./Modules/nsg-flow-log"
  resource_group_name = module.BaseInfrastructure.resource_group_name
  flow_logs               = var.flow_logs
  nsg_ids_map             = module.BaseInfrastructure.map_nsg_ids
  storage_account_ids_map =  module.BaseInfrastructure.sa_ids_map
  workspace_id            = module.BaseInfrastructure.law_workspace_id
  workspace_resource_id   = module.BaseInfrastructure.law_id
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the NSG flow log module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the NSG flow log module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the NSG flow log module.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming conventions.
2.  While declaring variables with data type 'map(object)'. It's mandatory to define all the objects.If you don't want to use any specific objects define it as null or empty list as per the object data type.

    - for example:

    ```hcl
     variable "example" {
     type = map(object({
     name         = string
     permissions  = list(string)
     cmk_enable   = bool
     auto_scaling = string
     }))
    ```

    - In above example, if you don't want to use the objects permissions and auto_scaling, you can define it as below.

    ```hcl
      example = {
         name = "example"
         permissions = []
         auto_scaling = null
         }
    ```

3.  Please make sure all the Required parameters are declared.Refer below
    section to understand the required and optional parameters of this module.

4.  Please verify that the values provided to the variables are with in the allowed values.Refer below section to understand the allowed values to each parameter.

## Inputs

# **Required Parameters**

## resource_group_name `string`

    The name of the resource group in which the Log Analytics workspace will be  created.

## flow_logs `map(object({}))`

| Attribute                | Data Type | Field Type | Description                                                 | Allowed Values |
| :----------------------- | :-------: | :--------: | :---------------------------------------------------------- | :------------- |
| nsg_name                 |  string   |  required  | name of the NSG to which nsg flow logs to be enabled        | NA             |
| storage_account_name     |  string   |  required  | name of the storage account in which flow logs to be stored | NA             |
| network_watcher_name     |  string   |  required  | name of the network watcher                                 | NA             |
| network_watcher_rg_name  |  string   |  required  | name of the network watcher rg name                         | NA             |
| retention_days           |  string   |  required  | The number of days to retain flow log records.              | NA             |
| enable_traffic_analytics |   bool    |  optional  | enable traffic analytics                                    | NA             |
| interval_in_minutes      |  number   |  optional  | How frequently service should do flow analytics in minutes. | NA             |

## nsg_ids_map `map(string)`

    map of nsg id's

## storage_account_ids_map `map(string)`

     map of storage account id's

# **Optional Parameters**

## workspace_id `string`

    log analytics work space id, required only when using traffic analytics

## workspace_resource_id `string`

     log analytics work space resource id, required only when using traffic analytics

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_network_watcher_flow_log](https://www.terraform.io/docs/providers/azurerm/r/network_watcher_flow_log.html) <br />
