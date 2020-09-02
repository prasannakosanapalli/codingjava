# Create Virtual Machines in Azure

This module allows you to create one or multiple Virtual Machines in Azure.

## Features

1.  Create one or multiple Virtual Machines in an existing resource group.
2.  Create public and private ssh key for login and store them in Key Vault.
3.  Allows to create additional data disks for Virtual Machine.
4.  Encrypt both os and data disks of VM using customer managed key.
5.  Add Virtual Machines to the backend pools of LB.
6.  Associate Application Security Groups to Virtual Machine.
7.  Enable MSI on Virtual Machine and create Key Vault Access Policy for VM Principal Id.
8.  Install Storage Diagnostics, Log Analytics, VMInsights and NetworkWatcher Extensions on Virtual Machine.
9.  Enables Backup to Recovery Services Vault for Virtual Machine.

## Example of Module Consumption

```hcl
module "Virtualmachine" {
  source                                   = "../../common-library/TerraformModules/VirtualMachine"
  resource_group_name                      = module.BaseInfrastructure.resource_group_name
  linux_vms                                = var.linux_vms
  linux_vm_nics                            = var.linux_vm_nics
  availability_sets                        = var.availability_sets
  linux_image_ids                          = local.linux_image_ids
  administrator_user_name                  = var.administrator_user_name
  administrator_login_password             = var.administrator_login_password
  key_vault_id                             = module.BaseInfrastructure.key_vault_id
  subnet_ids                               = module.BaseInfrastructure.map_subnet_ids
  lb_backend_address_pool_map              = module.LoadBalancer.pri_lb_backend_map_ids
  recovery_services_vaults                 = module.RecoveryServicesVault.map_recovery_vaults
  app_security_group_ids_map               = module.ApplicationSecurityGroup.app_security_group_ids_map
  application_gateway_backend_pool_ids_map = module.ApplicationGateway.application_gateway_backend_pool_ids_map
  application_gateway_backend_pools        = module.ApplicationGateway.application_gateway_backend_pools
  sa_bootdiag_storage_uri                  = module.BaseInfrastructure.primary_blob_endpoint[0]
  diagnostics_sa_name                      = module.BaseInfrastructure.sa_name[0]
  law_workspace_id                         = module.BaseInfrastructure.law_workspace_id
  law_workspace_key                        = module.BaseInfrastructure.law_key
  managed_data_disks                       = var.managed_data_disks
  lb_nat_rule_map                          = module.LoadBalancer.pri_lb_natrule_map_ids
  vm_additional_tags                       = var.additional_tags
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.RecoveryServicesVault.depended_on_rsv,
    module.BaseInfrastructure.depended_on_sa, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the Virtual Machine module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the Virtual Machine module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the Virtual Machine module.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming conventions.
2.  While declaring variables with data type 'map(object)', it's mandatory to define all the objects. If you don't want to use any specific objects define it as null or empty list as per the object data type.

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
       name         = "example"
       permissions  = []
       auto_scaling = null
    }
    ```

3.  Please make sure all the Required parameters are declared.Refer below section to understand the required and optional parameters of this module.

4.  Please verify that the values provided to the variables are with in the allowed values.Refer below section to understand the allowed values to each parameter.

## Inputs

### **Required Parameters**

#### resource_group_name `string`

    Description: Specifies the name of the resource group in which to create the Virtual Machines.

#### linux_vms `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Virtual Machines.

| Attribute                        |    Data Type     | Field Type | Description                                                                                                                       | Allowed Values                                           |
| :------------------------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------- |
| name                             |      string      |  Required  | The name of the Linux Virtual Machine. Changing this forces a new resource to be created.                                         |                                                          |
| vm_size                          |      string      |  Required  | The SKU which should be used for this Virtual Machine, such as Standard_F2.                                                       |                                                          |
| zone                             |      string      |  Optional  | The Zone in which this Virtual Machine should be created. Changing this forces a new resource to be created.                      |                                                          |
| assign_identitty                 |       bool       |  Optional  | Specifies whether to enable Managed System Identity for the Virtual Machine.                                                      | true, false                                              |
| avaialability_set_key            |      string      |  Optional  | key name of the availability set                                                                                                  |                                                          |
| lb_backend_pool_names            |   list(string)   |  Optional  | Specifies the list of Load Balancer Backend Pool Names which this VM Network Interface should be connected to.                    |                                                          |
| vm_nic_keys                      |   list(string)   |  Optional  | Specifies the list of NIC key names which shoudl be associated to the VM|                                                          |
| lb_nat_rule_names                |   list(string)   |  Optional  | Specifies the list of Load Balancer NAT rule Names which this VM Network Interface should be connected to.                        |                                                          |
| app_security_group_names         |   list(string)   |  Optional  | Specifies the list of Application Security Group Names which this VM Network Interface should be connected to.                    |                                                          |
| disable_password_authentication  |       bool       |  Optional  | Should Password Authentication be disabled on this Virtual Machine? Defaults to true.                                             | true, false                                              |
| source_image_reference_publisher |      string      |  Optional  | Specifies the publisher of the image used to create the virtual machines.                                                         |                                                          |
| source_image_reference_offer     |      string      |  Optional  | Specifies the offer of the image used to create the virtual machines.                                                             |                                                          |
| source_image_reference_sku       |      string      |  Optional  | Specifies the SKU of the image used to create the virtual machines.                                                               |                                                          |
| source_image_reference_version   |      string      |  Optional  | Specifies the version of the image used to create the virtual machines.                                                           |                                                          |
| storage_os_disk_caching          |      string      |  Optional  | The Type of Caching which should be used for the Internal OS Disk.                                                                | None, ReadOnly and ReadWrite                             |
| managed_disk_type                |      string      |  Optional  | The Type of Storage Account which should back this the Internal OS Disk.                                                          | Standard_LRS, StandardSSD_LRS, Premium_LRS, UltraSSD_LRS |
| disk_size_gb                     |      number      |  Optional  | The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. |                                                          |
| write_accelerator_enabled        |       bool       |  Optional  | Should Write Accelerator be Enabled for this OS Disk? Defaults to false.                                                          | true, false                                              |
| enable_cmk_disk_encryption       |       bool       |  Optional  | Specifies whether to enable encryption using Customer Managed Keys for the Virtual Machine.                                       | true, false                                              |
| recovery_services_vault_key      |      string      |  Optional  | Specifies the key name from Recovery Servie Vault map to be used for VM Backup.                                                   |                                                          |
| custom_data_path                 |      string      |  Optional  | Specifies the External Path for custom data script file.                                                                          |                                                          |
| custom_data_args                 |   map(string)    |  Optional  | Specifies the arguments passed to the custom data script file.                                                                    |                                                          |
| diagnostics_storage_config_path  |      string      |  Optional  | Specifies the External Path for diagnostics storage extension config file.                                                        |                                                          |
| custom_script                    |    object({})    |  Optional  | Specifies the Custom Script Extension configuration details as mentioned in the **_custom_script_** block.                        |                                                          |

#### ip_configuration

| Attribute | Data Type | Field Type | Description                                         | Allowed Values |
| :-------- | :-------: | :--------: | :-------------------------------------------------- | :------------- |
| name      |  string   |  Required  | Specifies the name used for this IP Configuration.  |                |
| static_ip |  string   |  Optional  | The Static Private IP Address which should be used. |                |

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

    Description: Specifies the username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.

#### dependencies `list(any)`

    Description: Specifies the modules that the Virtual Machine Resource depends on.

    Default: []

### **Optional Parameters**

#### availability_sets `map(object({}))`

    Description: Specifies the Map of objects containing attributes for availability set.

| Attribute                    | Data Type | Field Type | Description                                           | Allowed Values |
| :--------------------------- | :-------: | :--------: | :---------------------------------------------------- | :------------- |
| name                         |  string   |  Required  | The name of the availability set                      |                |
| platform_update_domain_count |  string   |  optional  | Specifies the number of update domains that are used. |                |
| platform_fault_domain_count  |  string   |  optional  | Specifies the number of fault domains that are used.  |                |


#### linux_vm_nics `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Virtual Machines.

| Attribute                        |    Data Type     | Field Type | Description                                                                                                                       | Allowed Values                                           |
| :------------------------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------- |
| name                             |      string      |  Required  | Name of the Network interface|                                                          |
| subnet_name                      |      string      |  Required  | Name of the subnet|                                                          |
| internal_dns_name_label          |      string      |  optional  | The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.|                                                          |
| enable_ip_forwarding             |      bool        |  optional  | Should IP Forwarding be enabled? |                                                          |
| enable_accelerated_networking    |      bool        |  optional  | Should Accelerated Networking be enabled? |                                                          |  
| dns_servers                      |     list(string) |  optional  | A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. |                                                          |  
| nic_ip_configurations            |     object({})   |  Required  | list of objects of ip configurations |                                                          |  

#### nic_ip_configurations `object({})` 
| Attribute                        |    Data Type     | Field Type | Description                                                                                                                       | Allowed Values                                           |
| :------------------------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------- |
| name                             |      string      |  Required  | Name of the IP configuration                                                          |
| static_ip                        |      string      |  Required  | static ip which should be associated to the nic                                                          |

#### linux_image_ids `map(string)`

    Description: Specifies the Map of image Id's from which the Virtual Machines should be created.

    Default: {}

#### administrator_login_password `string`

    Description: Specifies the password of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.

#### lb_backend_address_pool_map `map(string)`

    Description: Map of network interfaces internal load balancers backend pool id's.

    Default: {}

#### app_security_group_ids_map `map(string)`

    Description: Specifies the Map of network interfaces Application Security Group Id's.

    Default: {}

#### recovery_services_vaults `map(any)`

    Description: Map of Recovery Services Vault and Azure VM Backup Policy Resources.

    Default: {}

#### vm_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Virtual Machine resources tags, in addition to the resource group tags.

    Default: {}

#### managed_data_disks `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Virtual Machine Data Disks.

| Attribute                 | Data Type | Field Type | Description                                                                                                                                                       | Allowed Values                                             |
| :------------------------ | :-------: | :--------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------- |
| disk_name                 |  string   |  Required  | Specifies the name of the Managed Disk. Changing this forces a new resource to be created.                                                                        |                                                            |
| vm_name                   |  string   |  Required  | Specifies the Name of the Virtual Machine to which the Data Disk should be attached.                                                                              |                                                            |
| lun                       |  string   |  Required  | Specifies the Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine.                                                          |                                                            |
| storage_account_type      |  string   |  Optional  | Specifies the type of storage to use for the managed disk.                                                                                                        | Standard_LRS, Premium_LRS, StandardSSD_LRS or UltraSSD_LRS |  |
| disk_size                 |  number   |  optional  | Specifies the size of the managed disk to create in gigabytes. Required for a new managed disk.                                                                   |                                                            |
| caching                   |  string   |  Optional  | Specifies the caching requirements for the Data Disk.                                                                                                             | None, ReadOnly and ReadWrite                               |
| write_accelerator_enabled |   bool    |  Optional  | Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS managed disks with no caching and M-Series VMs. Defaults to false. | true, false                                                |
| create_option             |  string   |  Optional  | The method to use when creating the managed disk. Changing this forces a new resource to be created. Defaults to Empty.                                           | Empty, Copy, Restore                                       |
| os_type                   |  string   |  Optional  | Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Defaults to Linux.                             | Linux or Windows                                           |
| source_resource_id        |  string   |  Optional  | The ID of an existing Managed Disk to copy `create_option` is **_Copy_** or the recovery point to restore when `create_option` is **_Restore_**.                  |                                                            |

#### windows_vms `map(object({}))`

    Map of Windows VM's to be created in a resource group.

| Attribute                        |  Data Type   | Field Type | Description                                                                                                                       | Allowed Values                                           |
| :------------------------------- | :----------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------- |
| name                             |    string    |  Required  | The name of the Linux Virtual Machine. Changing this forces a new resource to be created.                                         |                                                          |
| vm_size                          |    string    |  Required  | The SKU which should be used for this Virtual Machine, such as Standard_F2.                                                       |                                                          |
| zone                             |    string    |  Optional  | The Zone in which this Virtual Machine should be created. Changing this forces a new resource to be created.                      |                                                          |
| assign_identitty                 |     bool     |  Optional  | Specifies whether to enable Managed System Identity for the Virtual Machine.                                                      | true, false                                              |
| subnet_name                      |    string    |  Optional  | Specifies the Name of the subnet in which Virtual Machine should be deployed.                                                     |                                                          |
| lb_backend_pool_name             | list(string) |  Optional  | Specifies the Load Balancer Backend Pool Name which this VM Network Interface should be connected to.                             |                                                          |
| source_image_reference_publisher |    string    |  Optional  | Specifies the publisher of the image used to create the virtual machines.                                                         |                                                          |
| source_image_reference_offer     |    string    |  Optional  | Specifies the offer of the image used to create the virtual machines.                                                             |                                                          |
| source_image_reference_sku       |    string    |  Optional  | Specifies the SKU of the image used to create the virtual machines.                                                               |                                                          |
| source_image_reference_version   |    string    |  Optional  | Specifies the version of the image used to create the virtual machines.                                                           |                                                          |
| storage_os_disk_caching          |    string    |  Optional  | The Type of Caching which should be used for the Internal OS Disk.                                                                | None, ReadOnly and ReadWrite                             |
| managed_disk_type                |    string    |  Optional  | The Type of Storage Account which should back this the Internal OS Disk.                                                          | Standard_LRS, StandardSSD_LRS, Premium_LRS, UltraSSD_LRS |
| disk_size_gb                     |    number    |  Optional  | The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. |                                                          |
| write_accelerator_enabled        |     bool     |  Optional  | Should Write Accelerator be Enabled for this OS Disk? Defaults to false.                                                          | true, false                                              |
| internal_dns_name_label          |    string    |  Optional  | The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.                    |                                                          |
| enable_ip_forwarding             |     bool     |  Optional  | Should IP Forwarding be enabled? Defaults to false.                                                                               | true, false                                              |
| enable_accelerated_networking    |     bool     |  Optional  | Should Accelerated Networking be enabled? Defaults to false.                                                                      | true, false                                              |
| dns_servers                      | list(string) |  Optional  | A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.                                  |                                                          |
| static_ip                        |    string    |  Optional  | The Static IP Address which should be used.                                                                                       |                                                          |
| disk_encryption_set_id           |    string    |  Optional  | Specifies the Disk Encryption Set Id.                                                                                             |                                                          |
| custom_data_path                 |    string    |  Optional  | Specifies the External Path for custom data script file.                                                                          |                                                          |
| custom_data_args                 | map(string)  |  Optional  | Specifies the arguments passed to the custom data script file.                                                                    |                                                          |

#### windows_image_id `string`

    Description: Specifies the Id of the Windows Image which each Virtual Machines should be created from.

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_linux_virtual_machine](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine.html) <br />
[azurerm_storage_account](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html) <br />
[azurerm_key_vault_key](https://www.terraform.io/docs/providers/azurerm/r/key_vault_key.html) <br />
[azurerm_key_vault_secret](https://www.terraform.io/docs/providers/azurerm/r/key_vault_secret.html) <br />
[azurerm_key_vault_access_policy](https://www.terraform.io/docs/providers/azurerm/r/key_vault_access_policy.html) <br />
[azurerm_disk_encryption_set](https://www.terraform.io/docs/providers/azurerm/r/disk_encryption_set.html) <br />
[azurerm_role_assignment](https://www.terraform.io/docs/providers/azurerm/r/role_assignment.html) <br />
[azurerm_network_interface](https://www.terraform.io/docs/providers/azurerm/r/network_interface.html) <br />
[azurerm_network_interface_backend_address_pool_association](https://www.terraform.io/docs/providers/azurerm/r/network_interface_backend_address_pool_association.html) <br />
[azurerm_network_interface_application_security_group_association](https://www.terraform.io/docs/providers/azurerm/r/network_interface_application_security_group_association.html) <br />
[azurerm_backup_protected_vm](azurerm_backup_protected_vm) <br />
[azurerm_managed_disk](https://www.terraform.io/docs/providers/azurerm/r/managed_disk.html) <br />
[azurerm_virtual_machine_data_disk_attachment](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_data_disk_attachment.html) <br />
[azurerm_virtual_machine_extension](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html) <br />
