# Create Azure SQL Server and Azure SQL Databases in Azure

This Module allows you to create and manage Azure SQL Server and one or many Azure SQL Databases in Microsoft Azure.

## Features

This module will:

- Create Azure SQL Server in Microsoft Azure.
- Create one or many Azure SQL Databases with in the created Azure SQL Server.
- Create Secondary/Failover Azure SQL Server.
- Create a failover group of databases on a collection of Azure SQL servers.
- Create one or many Azure SQL Virtual Network Rules.
- Create one or many Azure SQL Firewall Rules.
- Allow/Deny Public Network Access to Azure SQL Server.
- Add Azure SQL Server Admin Login Password to Key Vault secrets.

## Usage

```hcl
module "AzureSqlDatabase" {
  source                              = "../../common-library/TerraformModules/AzureSqlDatabase"
  resource_group_name                 = module.BaseInfrastructure.resource_group_name
  subnet_ids                          = module.BaseInfrastructure.map_subnet_ids
  key_vault_id                        = module.BaseInfrastructure.key_vault_id
  server_name                         = var.server_name
  database_names                      = var.database_names
  allowed_subnet_names                = var.allowed_subnet_names
  azuresql_version                    = var.azuresql_version
  assign_identity                     = var.assign_identity
  max_size_gb                         = var.max_size_gb
  sku_name                            = var.sku_name
  administrator_login_password        = var.administrator_login_password
  administrator_login_name            = var.administrator_user_name
  enable_failover_server              = var.enable_failover_server
  failover_location                   = var.failover_location
  azuresql_additional_tags            = var.additional_tags
  firewall_rules                      = var.firewall_rules
  private_endpoint_connection_enabled = var.private_endpoint_connection_enabled
  dependencies = [
    module.BaseInfrastructure.depended_on_kv, module.PrivateEndpoint.depended_on_ado_pe
  ]
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

    Description: Specifies the name of the resource group in which to create the Azure SQL Server.

#### subnet_ids `Map(string)`

    Description: Specifies the Map of Subnet Id's.

#### key_vault_id `string`

    Description: The Id of the Key Vault to which all secrets should be stored.

#### server_name `string`

    Description: Specifies the name of the Microsoft Azure SQL Server. This needs to be globally unique within Azure.

#### database_names `list(string)`

    Description: Specifies the list of Azure SQL Database names.

#### administrator_login_name `string`

    Description:  The Administrator Login for the Azure SQL Server.

    Default: "dbadmin"

#### administrator_login_password `string`

    Description: The Password associated with the administrator_login for the Azue SQL Server.

#### azuresql_version `string`

    Description:  Specifies the version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server).

    Default: "12.0"

#### assign_identity `bool`

    Description: Specifies whether to enable Managed System Identity for the Azure SQL Server

    Default: false

#### private_endpoint_connection_enabled `bool`

    Description: Specify if only private endpoint connections will be allowed to access this resource.

    Default: false

#### allowed_subnet_names `list(string)`

    Description: The list of subnet names that the Azure SQL server will be connected to.

#### dependencies `list(any)`

    Description: Specifies the modules that the Azure SQL Server Resource depends on.

    Default: []

### **Optional Parameters**

#### azuresql_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Azure SQL Server resources tags, in addition to the resource group tags.

    Default: {}

#### max_size_gb `number`

    Description: The max size of the database in gigabytes.

#### sku_name `string`

    Description:  Specifies the name of the sku used by the database. Changing this forces a new resource to be created. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100.

#### enable_failover_server `bool`

    Description: Specifies whether to enable failover Azure SQL Server or not.

    Default: false

#### failover_location `string`

    Description: Specifies the supported Azure location where the failover Azure SQL Server exists.

#### firewall_rules `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Azure SQL Server firewall Rules.

```hcl
Default: {
            "default" = {
                name             = "azuresql-firewall-rule-default"
                start_ip_address = "0.0.0.0"
                end_ip_address   = "0.0.0.0"
            }
        }
```

| Attribute        | Data Type | Field Type | Description                                                                    | Allowed Values |
| :--------------- | :-------: | :--------: | :----------------------------------------------------------------------------- | :------------- |
| name             |  string   |  Required  | Specifies the name of the Azure SQL Firewall Rule.                             |                |
| start_ip_address |  string   |  Required  | Specifies the starting IP address to allow through the firewall for this rule. |                |
| end_ip_address   |  string   |  Required  | Specifies the ending IP address to allow through the firewall for this rule.   |                |

## Outputs

#### azuresql_server_id

    Description: The server id of Azure SQL Server.

#### azuresql_server_name

    Description: The server name of Azure SQL Server.

#### azuresql_fqdn

    Description: The fully qualified domain name of the Azure SQL Server.

#### azuresql_databases_names

    Description: List of all Azure SQL database resource names.

#### azuresql_databases_ids

    Description: The list of all Azure SQL database resource ids.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_sql_server](https://www.terraform.io/docs/providers/azurerm/r/sql_server.html) <br/>
[azurerm_sql_database](https://www.terraform.io/docs/providers/azurerm/r/sql_database.html) <br/>
[azurerm_sql_virtual_network_rule](https://www.terraform.io/docs/providers/azurerm/r/sql_virtual_network_rule.html) <br/>
[azurerm_sql_firewall_rule](https://www.terraform.io/docs/providers/azurerm/r/sql_firewall_rule.html) <br />
[azurerm_mysql_configuration](https://www.terraform.io/docs/providers/azurerm/r/mysql_configuration.html)
