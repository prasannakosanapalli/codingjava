# Create Key Vault in Azure

This Module allows you to create keyvault in azure.

## Features

This module will:

1. Create one Key Vault in Microsoft Azure.
2. Create one or multiple Secrets in the Key Vault.
3. Add multiple Key Vault Access Policies to object ID's, azure ad groups and user principals.
4. Enabling Storage and LAW Diagnostic logs on the Key Vault.

## usage

```hcl
module "KeyVault" {
  source                           = "../KeyVault"
  resource_group_name              = module.BaseInfrastructure.resource_group_name
  storage_account_ids_map          = module.StorageAccount.sa_ids_map
  name                             = var.name
  soft_delete_enabled              = var.soft_delete_enabled
  purge_protection_enabled         = var.purge_protection_enabled
  enabled_for_deployment           = var.enabled_for_deployment
  enabled_for_disk_encryption      = var.enabled_for_disk_encryption
  enabled_for_template_deployment  = var.enabled_for_template_deployment
  sku_name                         = var.sku_name
  access_policies                  = var.access_policies
  network_acls                     = var.network_acls
  log_analytics_workspace_id       = var.log_analytics_workspace_id
  diagnostics_storage_account_name = var.diagnostics_storage_account_name
  kv_additional_tags               = var.additional_tags
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the Keyvault module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the Keyvault module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the Keyvault module.

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

3.  Please make sure all the Required parameters are declared.Refer below section to understand the required and optional parameters of this module.

4.  Please verify that the values provided to the variables are with in the allowed values.Refer below section to understand the allowed values to each parameter.

## Inputs

### **Required Parameters**

##### resource_group_name `string`

    Description: The name of the resource group in which Key Vault wil be created.

#### name `string`

    Description: Specifies the name of the Key Vault. Changing this forces a new resource to be created.

#### sku_name `string`

    Description: The Name of the SKU used for this Key Vault. Possible values are standard and premium.

#### log_analytics_workspace_id `string`

    Description: Specifies the Id of a Log Analytics Workspace where Diagnostics Data should be sent.

#### diagnostics_storage_account_name `string`

    Description: Specifies the name of the Storage Account where Diagnostics Data should be sent.

#### storage_account_ids_map `map(string)`

    Description: Map of Storage Account Id's.

### **Optional Parameters**

#### soft_delete_enabled `boolean`

    Description: Should Soft Delete be enabled for this Key Vault?. Once Soft Delete has been Enabled it's not possible to Disable it.

#### purge_protection_enabled `boolean`

    Description: Should Purge Protection enabled for this Key Vault?. Once Purge Protection has been Enabled it's not possible to Disable it. Support for disabling purge protection is being tracked in this Azure API issue. Deleting the Key Vault with Purge Protection Enabled will schedule the Key Vault to be deleted (which will happen by Azure in the configured number of days, currently 90 days - which will be configurable in Terraform in the future).

#### enabled_for_deployment `boolean`

    Description: Specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault.

#### enabled_for_disk_encryption `boolean`

    Description: Specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.

#### enabled_for_template_deployment `boolean`

    Description: Specify whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault.

#### access_policies `map(object({}))`

    Description: Specifies the Map of access policies for Key Vault.

| Attribute               |  Data Type   | Field Type | Description                                                        | Allowed Values                                                                                                                                                 |
| :---------------------- | :----------: | :--------: | :----------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| group_names             | list(string) |  Optional  | Active directory group names to which access polices to be created | NA                                                                                                                                                             |
| object_ids              | list(string) |  Required  | Object Id's to which access policies to be created                 | NA                                                                                                                                                             |
| user_principal_names    | list(string) |  Optional  | User prinicipal names to which access policies to be created       | NA                                                                                                                                                             |
| certificate_permissions | list(string) |  Optional  | List of Certificate Permissions                                    | backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers , update |
| key_permissions         | list(string) |  Optional  | List of key Permissions                                            | backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify , wrapKey                                |
| storage_permissions     | list(string) |  Optional  | List of storage_permissions Permissions                            | backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas , update                                            |
| secret_permissions      | list(string) |  Optional  | List of storage_permissions Permissions                            | backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas , update                                            |

#### kv_additional_tags `map(string)`

    Description: A map of additional tags to Key Vault resource.

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_key_vault](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html) <br />
[azurerm_key_vault_access_policy](https://www.terraform.io/docs/providers/azurerm/r/key_vault_access_policy.html) <br />
[azurerm_key_vault_secret](https://www.terraform.io/docs/providers/azurerm/r/key_vault_secret.html)
