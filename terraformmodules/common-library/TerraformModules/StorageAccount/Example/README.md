# Create Storage Accounts in Azure.

    This Module allows you to create one or multiple Storage Accounts in azure.

## Features

1.  Create one or multiple Storage Accounts in Azure.
2.  Create one or multiple containers, blobs, queues, tables and file shares in the respective Storage Account.
3.  Encrypt the Storage Account using Customer Managed key (CMK).
4.  Enable MSI identity for the created Storage Account.

## usage

```hcl
module "StorageAccount" {
  source              = "../../common-library/TerraformModules/StorageAccount"
  resource_group_name = module.BaseInfrastructure.resource_group_name
  key_vault_id        = module.BaseInfrastructure.key_vault_id
  storage_accounts    = var.storage_accounts
  containers          = var.containers
  blobs               = var.blobs
  queues              = var.queues
  file_shares         = var.file_shares
  tables              = var.tables
  sa_additional_tags  = var.additional_tags
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the storage account module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the storage account module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the storage account module.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming conventions.
2.  While declaring variables with data type 'map(object)'. It's mandatory to define all the objects. If you don't want to use any specific objects define it as null or empty list as per the object data type.

    - for example:

    ```hcl
     variable "example" {
       type         = map(object({
       name         = string
       permissions  = list(string)
       cmk_enable   = bool
       auto_scaling = string
     }))
    ```

    - In above example, if you don't want to use the objects permissions and auto_scaling, you can define it as below.

    ```hcl
     example = {
       name          = "example"
       permissions   = []
       auto_scaling  = null
     }
    ```

3.  Please make sure all the Required parameters are declared. Refer below section to understand the required and optional parameters of this module.

4.  Please verify that the values provided to the variables are with in the allowed values.Refer below section to understand the allowed values to each parameter.

## Inputs

### **Required Parameters**

#### resource_group_name `string`

    The name of the resource group in which storage account will be created.

#### storage_accounts `map(object({}))`

    Map of storage accounts which needs to be created in a resource group

| Attribute       | Data Type  | Field Type | Description                                                                                                                                                                                                               | Allowed Values                                                    |
| :-------------- | :--------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------- |
| name            |   string   |  Required  | Name of storage account                                                                                                                                                                                                   |                                                                   |
| sku             |   string   |  Required  | sku is the combination of combination of values of account_tier and account_replication_type. for example if your account_tier is "Standard" and account_replication_type is LRS, you should define it as 'Standard_LRS'. | LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS                             |
| account_kind    |   string   |  Optional  | Defines the Kind of Storage Account.                                                                                                                                                                                      | BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 |
| access_tier     |   string   |  Optional  | Defines the Tier to use for this Storage Account.                                                                                                                                                                         | Standard, Premium                                                 |
| assign_identity |    bool    |  Optional  | Assign MSI to Storage Account.                                                                                                                                                                                            |                                                                   |
| cmk_enable      |    bool    |  Optional  | Enable CMK encryption on Storage Account.                                                                                                                                                                                 |                                                                   |
| network_rules   | object({}) |  Optional  | Specifies **_network_rules_** block for Storage Account as below.                                                                                                                                                         |                                                                   |

#### network_rules `object({})`

| Attribute                  | Data Type | Field Type | Description                                                             | Allowed Values                           |
| :------------------------- | :-------: | :--------: | :---------------------------------------------------------------------- | :--------------------------------------- |
| bypass                     |  string   |  Optional  | list of services which needs to be bypassed                             | Logging, Metrics, AzureServices, or None |
| default_action             |  string   |  Required  | Specifies the default action of allow or deny when no other rules match |                                          |
| ip_rules                   |  string   |  Optional  | List of IP ranges in CIDR format                                        |                                          |
| virtual_network_subnet_ids |  string   |  Optional  | List of resource id's of subnets needs to be whitelisted                |                                          |

#### dependencies `list(any)`

    Description: Specifies the modules that the Storage Account Resource depends on.

    Default: []

### **Optional Parameters**

#### containers `map(object({}))`

    Map of Storage Containers to be created in a storage account.

| Attribute             | Data Type | Field Type | Description             | Allowed Values                                  |
| :-------------------- | :-------: | :--------: | :---------------------- | :---------------------------------------------- |
| name                  |  string   |  Required  | Name of container       |                                                 |
| storage_account_name  |  string   |  Required  | Name of storage account |                                                 |
| container_access_type |  string   |  Optional  | Name of storage account | blob, container or private. Defaults to private |

#### blobs `map(object({}))`

    Map of Storage blobs to be created in a storage account.

| Attribute              | Data Type | Field Type | Description                                                                                                                 | Allowed Values        |
| :--------------------- | :-------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------- |
| name                   |  string   |  Required  | Name of blob                                                                                                                |                       |
| storage_account_name   |  string   |  Required  | Name of storage account                                                                                                     |                       |
| storage_container_name |  string   |  Required  | Name of storage container                                                                                                   |                       |
| type                   |  string   |  Optional  | The type of the storage blob to be created                                                                                  | Append, Block or Page |
| size                   |  string   |  Optional  | Used only for page blobs to specify the size in bytes of the blob to be created.                                            | Append, Block or Page |
| type                   |  string   |  Optional  | The type of the storage blob to be created                                                                                  | Append, Block or Page |
| content_type           |  string   |  Optional  | The content type of the storage blob                                                                                        | Append, Block or Page |
| source_uri             |  string   |  Optional  | The URI of an existing blob, or a file in the Azure File service, to use as the source contents for the blob to be created. |                       |
| metadata               |  string   |  Optional  | A map of custom blob metadata.                                                                                              |                       |

#### file_shares `map(object({}))`

    Map of Storages File Shares to be created in a storage account.

| Attribute            | Data Type | Field Type | Description                                  | Allowed Values                                                                                                                                                                                        |
| :------------------- | :-------: | :--------: | :------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name                 |  string   |  Required  | Name of file share                           |                                                                                                                                                                                                       |
| storage_account_name |  string   |  Required  | Name of storage account                      |                                                                                                                                                                                                       |
| quota                |  string   |  Required  | The maximum size of the share, in gigabytes. | For Standard storage accounts, this must be greater than 0 and less than 5120 GB (5 TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and less than 102400 GB (100 TB). |

#### queues `map(object({}))`

    Map of storage queues to be created in a storage account.

| Attribute            | Data Type | Field Type | Description             | Allowed Values |
| :------------------- | :-------: | :--------: | :---------------------- | :------------- |
| name                 |  string   |  Required  | Name of queue           |                |
| storage_account_name |  string   |  Required  | Name of storage account |                |

#### tables `map(object({}))`

    Map of tables to be created in a storage account.

| Attribute            | Data Type | Field Type | Description             | Allowed Values |
| :------------------- | :-------: | :--------: | :---------------------- | :------------- |
| name                 |  string   |  Required  | Name of the table       |                |
| storage_account_name |  string   |  Required  | Name of storage account |                |

#### sa_additional_tags `map(string)`

    Map of tags for the storage account.

## key_vault_id `string`

    resource id of key vault for creating access policies for storage MSI and creating a key for storage encryption.

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_storage_account](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html) <br />
