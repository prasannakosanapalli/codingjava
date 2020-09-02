# Create PostgreSql Databases in Azure

This module allows you to create one or multiple PostgreSql Servers in azure.

## Features

1. Create one or multiple PostgreSql Servers in Azure.
2. Create one or multiple PostgreSql Databases in the respective PostgreSql Server.
3. Create VNET Rules in PostgreSql Server.
4. Create Firewall Rules in PostgreSql Server.
5. Set PostgreSQL Configuration values on a PostgreSQL Server.

## usage

```hcl
module "PostgreSqlDatabase" {
  resource_group_name        = module.BaseInfrastructure.resource_group_name
  postgresql_servers         = var.postgresql_servers
  postgresql_databases       = var.postgresql_databases
  key_vault_id               = module.BaseInfrastructure.key_vault_id
  subnet_ids                 = module.BaseInfrastructure.map_subnet_ids
  postgresql_configurations  = var.postgresql_configurations
  postgresql_additional_tags = var.additional_tags
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.PrivateEndpoint.depended_on_ado_pe
  ]
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the PostgresqlDB module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the PostgresqlDB module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the PostgresqlDB module.

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

    Description: The Name of the resource group in which Azure PostgreSql Server will be created.

#### postgresql_servers `map(object({}))`

    Description: Map of PostgreSql Server.

    Default: {}

| Attribute                        |  Data Type   | Field Type | Description                                                                                | Allowed Values                                               |
| :------------------------------- | :----------: | :--------: | :----------------------------------------------------------------------------------------- | :----------------------------------------------------------- |
| name                             |    string    |  Required  | Name of the postgresqlserver                                                               | NA                                                           |
| sku_name                         |    string    |  Required  | The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8). | NA                                                           |
| storage_mb                       |    string    |  Required  | Max storage allowed for a server                                                           | Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) |
| backup_retention_days            |    number    |  Optional  | Backup retention days for the server                                                       | values are between 7 and 35 days                             |
| enable_geo_redundant_backup      |     bool     |  Optional  | Turn Geo-redundant server backups on/off                                                   | NA                                                           |
| enable_auto_grow                 |     bool     |  Optional  | Enable/Disable auto-growing of the storage                                                 | NA                                                           |
| administrator_login              |    string    |  Optional  | The Administrator Login for the PostgreSQL Server                                          | NA                                                           |
| administrator_login_password     |    string    |  Optional  | The Administrator Login password for the PostgreSQL Server                                 | NA                                                           |
| version                          |    number    |  Optional  | Specifies the version of PostgreSQL to use                                                 | values are 9.5, 9.6, 10, 10.0, and 11                        |
| enable_ssl_enforcement           |     bool     |  Optional  | Specifies if SSL should be enforced on connections                                         | NA                                                           |
| ssl_minimal_tls_version_enforced |     bool     |  Optional  | The mimimun TLS version to support on the sever                                            | TLSEnforcementDisabled, TLS1_0, TLS1_1, and TLS1_2           |
| create_mode                      |    string    |  Optional  | The creation mode. Can be used to restore or replicate existing servers                    | Default, Replica, GeoRestore, and PointInTimeRestore         |
| enable_public_network_access     |     bool     |  Optional  | Whether or not public network access is allowed for this server                            | NA                                                           |
| allowed_subnet_names             | list(string) |  Optional  | names of the subnet which should be added in vnet rules                                    | NA                                                           |
| start_ip_address                 |    string    |  Optional  | Specifies the Start IP Address associated with the Firewall Rule                           | NA                                                           |
| end_ip_address                   |    string    |  Optional  | Specifies the end IP Address associated with the Firewall Rule                             | NA                                                           |
| end_ip_address                   |    string    |  Optional  | Specifies the end IP Address associated with the Firewall Rule                             | NA                                                           |

#### postgresql_databases `map(object({}))`

    Description: Map of PostgreSql Databases.

    Default: {}

| Attribute  | Data Type | Field Type | Description                       | Allowed Values |
| :--------- | :-------: | :--------: | :-------------------------------- | :------------- |
| name       |  string   |  Required  | Name of the postgresqldb          | NA             |
| server_key |  string   |  Required  | key name of the postgresql server | NA             |

#### dependencies `list(any)`

    Description: Specifies the modules that the PostgreSql Server Resource depends on.

    Default: []

### **Optional Parameters**

#### postgresql_configurations `map(object({}))`

    Description: Map of PostgreSql Server configurations.

    Default: {}

| Attribute  | Data Type | Field Type | Description                                         | Allowed Values |
| :--------- | :-------: | :--------: | :-------------------------------------------------- | :------------- |
| name       |  string   |  Required  | Name of the postgresql server configuration         | NA             |
| server_key |  string   |  Required  | key name of the postgresql server                   | NA             |
| value      |  string   |  Required  | Specifies the value of the PostgreSQL Configuration | NA             |

#### postgresql_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional PostgreSql Server resources tags, in addition to the resource group tags.

    Default: {}

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_postgresql_server](https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html) <br />
[azurerm_postgresql_database](https://www.terraform.io/docs/providers/azurerm/r/postgresql_database.html) <br />
[azurerm_postgresql_configuration](https://www.terraform.io/docs/providers/azurerm/r/postgresql_configuration.html) <br />
[azurerm_postgresql_firewall_rule](https://www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html) <br />
[azurerm_postgresql_virtual_network_rule](https://www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html)
