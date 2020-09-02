# Create Virtual Machines Scalesets in Azure.

This module allows you to create one or multiple Virtual Machine Scalesets in Azure.

## Features

1.  Create one or multiple Virtual Machine Scalesets in an existing resource group.
2.  Create public and private ssh key for login and store them in Key Vault.
3.  Encrypt both os and data disks of VMSS using customer managed key.
4.  Add Virtual Machine Scalesets to the backend pools of LB.
5.  Associate Application Security Groups to Virtual Machine Scaleset.
6.  Enable MSI on Virtual Machine Scaleset and create Key Vault Access Policy for VMSS Principal Id.
7.  Install Storage Diagnostics, Log Analytics, VMInsights and NetworkWatcher Extensions on Virtual Machine Scaleset.

## Example of Module Consumption

```hcl
module "VirtualmachineScaleSet" {
  source                                = "../../common-library/TerraformModules/VirtualMachineScaleSet"
  resource_group_name                   = module.BaseInfrastructure.resource_group_name
  key_vault_id                          = module.BaseInfrastructure.key_vault_id
  virtual_machine_scalesets             = var.vmss
  linux_image_ids                       = local.linux_image_ids
  custom_auto_scale_settings            = var.custom_auto_scale_settings
  administrator_user_name               = var.administrator_user_name
  administrator_login_password          = var.administrator_login_password
  subnet_ids                            = module.BaseInfrastructure.map_subnet_ids
  lb_probe_map                          = module.LoadBalancer.pri_lb_probe_map_ids
  lb_backend_address_pool_map           = module.LoadBalancer.pri_lb_backend_map_ids
  app_security_group_ids_map            = module.ApplicationSecurityGroup.app_security_group_ids_map
  application_gateway_backend_pools_map = module.ApplicationGateway.application_gateway_backend_pools_map
  sa_bootdiag_storage_uri               = module.BaseInfrastructure.primary_blob_endpoint[0]
  diagnostics_sa_name                   = module.BaseInfrastructure.sa_name[0]
  law_workspace_id                      = module.BaseInfrastructure.law_workspace_id
  law_workspace_key                     = module.BaseInfrastructure.law_key
  vmss_additional_tags                  = var.additional_tags
  lb_nat_pool_map              = module.LoadBalancer.pri_lb_natpool_map_ids
  zones                                 = module.LoadBalancer.pri_lb_zones
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.RecoveryServicesVault.depended_on_rsv,
    module.BaseInfrastructure.depended_on_sa, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the VMSS module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the VMSS module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the VMSS module.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming conventions.
2.  While declaring variables with data type 'map(object)', it's mandatory to define all the objects.If you don't want to use any specific objects define it as null or empty list as per the object data type.

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

3.  Please make sure all the Required parameters are declared.Refer below section to understand the required and optional parameters of this module.

4.  Please verify that the values provided to the variables are with in the allowed values. Refer below section to understand the allowed values to each parameter.

## Inputs

### **Required Parameters**

#### resource_group_name `string`

    Description: Specifies the name of the resource group in which to create the Virtual Machine Scalesets.

#### virtual_machine_scalesets `map(object({}))`

     Description: Specifies the Map of objects containing attributes for Virtual Machine Scalesets.

     Default: {}

| Attribute                          |    Data Type     | Field Type | Description                                                                                                                                                                                             | Allowed Values                                           |
| :--------------------------------- | :--------------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------- |
| name                               |      string      |  Required  | The name of the Linux Virtual Machine Scale Set. Changing this forces a new resource to be created.                                                                                                     |                                                          |
| vm_size                            |      string      |  Required  | The Virtual Machine SKU for the Scale Set, such as Standard_F2.                                                                                                                                         |                                                          |
| instances                          |      number      |  Required  | The number of Virtual Machines in the Scale Set.                                                                                                                                                        |                                                          |
| zones                              |   list(string)   |  Optional  | A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in. Changing this forces a new resource to be created.                                                   |                                                          |
| enable_rolling_upgrade             |       bool       |  Optional  | Specifies whether auto upgrades should be performed to Virtual Machine Instances. Defauls to false.                                                                                                     | true, false                                              |
| rolling_upgrade_policy             |    object({})    |  Optional  | Specifies the **_rolling_upgrade_policy_** block as defined below. This is Required and can only be specified when **_enable_rolling_upgrade_** is set to true.                                         |                                                          |
| assign_identitty                   |       bool       |  Optional  | Specifies whether to enable Managed System Identity for the Virtual Machine Scaleset.                                                                                                                   | true, false                                              |
| subnet_name                        |      string      |  Optional  | Specifies the Name of the Subnet which this IP Configuration should be connected to.                                                                                                                    |                                                          |
| lb_backend_pool_names              |   list(string)   |  Optional  | Specifies the list of Load Balancer Backend Pool Names from a Load Balancer which this VMSS should be connected to                                                                                      |                                                          |
| lb_nat_pool_names                  |   list(string)   |  Optional  | Specifies the list of Load Balancer NAT Pool Names from a Load Balancer which this VMSS should be associated to                                                                                         |                                                          |
| lb_probe_name                      |      string      |  Optional  | Specifies the Name of a Load Balancer Probe which should be used to determine the health of an instance. This is Required and can only be specified when **_enable_autoscaling_** is set to **_true_**. |
| app_security_group_names           |   list(string)   |  Optional  | Specifies the list of Application Security Group Names which this VMSS Network Interface should be connected to.                                                                                        |                                                          |
| disable_password_authentication    |       bool       |  Optional  | Should Password Authentication be disabled on this Virtual Machine Scale Set? Defaults to true.                                                                                                         | true, false                                              |
| source_image_reference_publisher   |      string      |  Optional  | Specifies the publisher of the image used to create the virtual machines.                                                                                                                               |                                                          |
| source_image_reference_offer       |      string      |  Optional  | Specifies the offer of the image used to create the virtual machines.                                                                                                                                   |                                                          |
| source_image_reference_sku         |      string      |  Optional  | Specifies the SKU of the image used to create the virtual machines.                                                                                                                                     |                                                          |
| source_image_reference_version     |      string      |  Optional  | Specifies the version of the image used to create the virtual machines.                                                                                                                                 |                                                          |
| storage_os_disk_caching            |      string      |  Optional  | The Type of Caching which should be used for the Internal OS Disk.                                                                                                                                      | None, ReadOnly and ReadWrite                             |
| managed_disk_type                  |      string      |  Optional  | The Type of Storage Account which should back this the Internal OS Disk.                                                                                                                                | Standard_LRS, StandardSSD_LRS, Premium_LRS, UltraSSD_LRS |
| disk_size_gb                       |      number      |  Optional  | The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine Scale Set is sourced from.                                                             |                                                          |
| write_accelerator_enabled          |       bool       |  Optional  | Should Write Accelerator be Enabled for this OS Disk? Defaults to false.                                                                                                                                | true, false                                              |
| enable_cmk_disk_encryption         |       bool       |  Optional  | Specifies whether to enable encryption using Customer Managed Keys for the Virtual Machine Scale Set.                                                                                                   | true, false                                              |
| enable_default_auto_scale_settings |       bool       |  Optional  | should enable default auto_scale settings for VMSS?                                                                                                                                                     | true, false                                              |
| enable_ip_forwarding               |       bool       |  Optional  | Does this Network Interface support IP Forwarding? Defaults to false.                                                                                                                                   | true, false                                              |
| enable_accelerated_networking      |       bool       |  Optional  | Does this Network Interface support Accelerated Networking? Defaults to false.                                                                                                                          | true, false                                              |
| storage_profile_data_disks         | list(object({})) |  Optional  | Specifies one or more **_storage_profile_data_disk_** blocks as defined below.                                                                                                                          |                                                          |
| custom_data_path                   |      string      |  Optional  | Specifies the External Path for custom data script file.                                                                                                                                                |                                                          |
| custom_data_args                   |   map(string)    |  Optional  | Specifies the arguments passed to the custom data script file.                                                                                                                                          |                                                          |
| diagnostics_storage_config_path    |      string      |  Optional  | Specifies the External Path for diagnostics storage extension config file.                                                                                                                              |                                                          |
| custom_script                      |    object({})    |  Optional  | Specifies the Custom Script Extension configuration details as mentioned in the **_custom_script_** block.                                                                                              |                                                          |

#### storage_profile_data_disk

| Attribute                 | Data Type | Field Type | Description                                                                                          | Allowed Values                                              |
| :------------------------ | :-------: | :--------: | :--------------------------------------------------------------------------------------------------- | :---------------------------------------------------------- |
| lun                       |  string   |  Required  | Specifies the Logical Unit Number of the Data Disk, which must be unique within the Virtual Machine. |                                                             |
| caching                   |  string   |  Required  | Specifies the type of Caching which should be used for this Data Disk.                               | None, ReadOnly and ReadWrite                                |
| storage_account_type      |  string   |  Required  | Specifies the Type of Storage Account which should back this Data Disk.                              | Standard_LRS, StandardSSD_LRS, Premium_LRS and UltraSSD_LRS |
| disk_size                 |  number   |  Required  | Specifies the size of the Data Disk which should be created.                                         |                                                             |
| write_accelerator_enabled |  string   |  Optional  | Should Write Accelerator be enabled for this Data Disk? Defaults to false.                           | true, false                                                 |

#### rolling_upgrade_policy

| Attribute                               | Data Type | Field Type | Description                                                                                                                                                                                                                                                                                                                             | Allowed Values |
| :-------------------------------------- | :-------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| max_batch_instance_percent              |  number   |  Required  | The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability.                                     |                |
| max_unhealthy_instance_percent          |  number   |  Required  | The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. |                |
| max_unhealthy_upgraded_instance_percent |  number   |  Required  | The maximum percentage of upgraded virtual machine instances that can be found to be in an unhealthy state. This check will happen after each batch is upgraded. If this percentage is ever exceeded, the rolling update aborts.                                                                                                        |                |
| pause_time_between_batches              |  string   |  Required  | The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format.                                                                                                                                                                |                |

#### custom_script

| Attribute          |  Data Type   | Field Type | Description                                                                                                                                                    | Allowed Values |
| :----------------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| commandToExecute   |    string    |  Required  | (Required if **_scriptPath_** not set) Specifies the entry point script to execute. Use this field instead if your command contains secrets such as passwords. |                |
| scriptPath         |    string    |  Required  | (Required if **_commandToExecute_** not set) Specifies the base64 encoded (and optionally gzip'ed) script executed by /bin/sh.                                 |                |
| scriptArgs         | map(string)  |  Optional  | Specifies the arguments that are passed to script mentioned in **_scriptPath_** attribute.                                                                     |                |
| fileUris           | list(string) |  Optional  | Specifies the URLs for file(s) to be downloaded.                                                                                                               |                |
| storageAccountName |    string    |  Optional  | Specifies the name of storage account. If you specify storage credentials, all fileUris must be URLs for Azure Blobs.                                          |                |

#### subnet_ids `map(string)`

    Description: Specifies the Map of Subnet Id's.

    Default: {}

#### diagnostics_sa_name `string`

    Description: storage account name where the diagnostic logs will be stored.

#### sa_bootdiag_storage_uri `string`

    Description: Specifies the URI of the blob diagnostics Storage Account in which boot diagnostics logs will be stored.

#### law_workspace_id `string`

    Description: Specifies the Log Analytics Workspace resource workspace id.

#### law_workspace_key `string`

    Description: Speifies the Log Analytics Workspace primary shared key.

#### key_vault_id `string`

    Description: Specifies the resource Id of the Key Vault where the ssh keys will be stored.

#### administrator_user_name `string`

    Description: Specifies the username of the local administrator used for the Virtual Machine Scaleset. Changing this forces a new resource to be created.

#### dependencies `list(any)`

    Description: Specifies the modules that the Virtual Machine Scale Set Resource depends on.

    Default: []

### **Optional Parameters**

#### linux_image_ids `map(string)`

    Description: Specifies the Map of image Id's from which the Virtual Machine Instances should be created.

    Default: {}

#### administrator_login_password `string`

    Description: Specifies the password of the local administrator used for the Virtual Machine Scaleset. Changing this forces a new resource to be created.

#### lb_backend_address_pool_map `map(string)`

    Description: Map of network interfaces internal load balancers backend pool id's.

    Default: {}

#### lb_probe_map `string`

    Description: Map of network interfaces internal load balancers health probe id's

    Default: {}

#### app_security_group_ids_map `map(string)`

    Description: Specifies the Map of network interfaces Application Security Group Id's.

    Default: {}

#### zones `list(string)`

    Description: "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in."

    Default: []

#### custom_auto_scale_settings `map(object({}))`

| Attribute         |   Data Type    | Field Type | Description                          | Allowed Values |
| :---------------- | :------------: | :--------: | :----------------------------------- | :------------- |
| name              |     string     |  Required  | name of the auto_scale settings      | NA             |
| vmss_key          |     string     |  Required  | key name of VMSS                     | NA             |
| profile_name      |     string     |  Required  | profile name for auto scale settings | NA             |
| default_instances |     string     |  Required  | number of default instances          | NA             |
| minimum_instances |     string     |  Required  | minimum number of instances          | NA             |
| maximum_instances |     string     |  Required  | maximum number of instances          | NA             |
| rule              | list(object{}) |  Required  | metric rules                         | NA             |

### rules `list(object)`

| Attribute   | Data Type | Field Type | Description                                                                                                                                                  | Allowed Values                                                                          |
| :---------- | :-------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------- |
| metric_name |  string   |  Required  | The name of the metric that defines what the rule monitors, such as Percentage CPU                                                                           | NA                                                                                      |
| time_grain  |  string   |  Required  | Specifies the granularity of metrics that the rule monitors, which must be one of the pre-defined values returned from the metric definitions for the metric | This value must be between 1 minute and 12 hours an be formatted as an ISO 8601 string. |
| time_window |  string   |  Required  | Specifies the time range for which data is collected, which must be greater than the delay in metric collection (which varies from resource to resource).    | value must be between 5 minutes and 12 hours and be formatted as an ISO 8601 string.    |
| operator    |  string   |  Required  | Specifies the operator used to compare the metric data and threshold                                                                                         | Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual.          |
| statistic   |  string   |  Required  | Specifies how the metrics from multiple instances are combined.                                                                                              | Average, Min and Max.                                                                   |
| threshold   |  string   |  Required  | Specifies the threshold of the metric that triggers the scale action                                                                                         | NA                                                                                      |
| direction   |  string   |  Required  | The scale direction                                                                                                                                          | Possible values are Increase and Decrease.                                              |
| type        |  string   |  Required  | The type of action that should occur.                                                                                                                        | Possible values are ChangeCount, ExactCount and PercentChangeCount.                     |
| value       |  string   |  Required  | The number of instances involved in the scaling action                                                                                                       | NA                                                                                      |
| cooldown    |  string   |  Required  | The amount of time to wait since the last scaling action before this action occurs.                                                                          | Must be between 1 minute and 1 week and formatted as a ISO 8601 string                  |

#### vm_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Virtual Machine resources tags, in addition to the resource group tags.

    Default: {}

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_linux_virtual_machine_scale_set](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html) <br />  
[azurerm_storage_account](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html) <br />
[azurerm_key_vault_key](https://www.terraform.io/docs/providers/azurerm/r/key_vault_key.html) <br />
[azurerm_key_vault_secret](https://www.terraform.io/docs/providers/azurerm/r/key_vault_secret.html) <br />
[azurerm_key_vault_access_policy](https://www.terraform.io/docs/providers/azurerm/r/key_vault_access_policy.html) <br />
[azurerm_disk_encryption_set](https://www.terraform.io/docs/providers/azurerm/r/disk_encryption_set.html) <br />
[azurerm_role_assignment](https://www.terraform.io/docs/providers/azurerm/r/role_assignment.html) <br />
[azurerm_virtual_machine_scale_set_extension](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_scale_set_extension.html)
