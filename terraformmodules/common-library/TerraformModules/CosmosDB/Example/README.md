# Create MySQL Server and MySQL Databases in Azure

This Module allows you to create and manage CosmosDB Account in Microsoft Azure.

## Features

This module will:

- Create CosmosDB Account in Microsoft Azure.
- Create Mongo Collection and Mongo Database within the CosmosDB Account.
- Create Cassandra Keyspace within the CosmosDB Account.
- Creates Cosmos Table within the CosmosDB Account.

## Usage

```hcl
module "CosmosDB" {
  source                           = "../../common-library/TerraformModules/CosmosDB"
  resource_group_name              = module.BaseInfrastructure.resource_group_name
  subnet_ids                       = module.BaseInfrastructure.map_subnet_ids
  storage_account_ids_map          = module.BaseInfrastructure.sa_ids_map
  log_analytics_workspace_id       = module.BaseInfrastructure.law_id
  allowed_subnet_names             = var.allowed_subnet_names
  cosmosdb_account                 = var.cosmosdb_account
  throughput                       = var.throughput
  enable_logs_to_storage           = var.enable_logs_to_storage
  enable_logs_to_log_analytics     = var.enable_logs_to_log_analytics
  diagnostics_storage_account_name = var.diagnostics_storage_account_name
  cosmosdb_additional_tags         = var.additional_tags
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

    Description: Specifies The name of the resource group in which the CosmosDB Account is created.

#### subnet_ids `Map(string)`

    Description: Specifies the Map of Subnet Id's.

#### allowed_subnet_names `list(string)`

    Description: The list of subnet names that the CosmosDB Account will be connected to.

#### cosmosdb_account `object({})`

    Description: Specifies the object containing attributes for CosmosDB Account.

| Attribute                         | Data Type | Field Type | Description                                                                                                                                                                                                                                                            | Allowed Values                                                                                               |
| :-------------------------------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------- |
| database_name                     |  string   |  Required  | Specifies the name of the CosmosDB Account. Changing this forces a new resource to be created.                                                                                                                                                                         |                                                                                                              |
| offer_type                        |  string   |  Required  | Specifies the Offer Type to use for this CosmosDB Account.                                                                                                                                                                                                             | Standard                                                                                                     |
| kind                              |  string   |  Optional  | Specifies the Kind of CosmosDB to create. Defaults to GlobalDocumentDB. Changing this forces a new resource to be created.                                                                                                                                             | GlobalDocumentDB , MongoDB                                                                                   |
| enable_multiple_write_locations   |   bool    |  Optional  | Enable multi-master support for this Cosmos DB account.                                                                                                                                                                                                                | true , false                                                                                                 |
| enable_automatic_failover         |   bool    |  Required  | Enable automatic fail over for this Cosmos DB account.                                                                                                                                                                                                                 | true , false                                                                                                 |
| is_virtual_network_filter_enabled |   bool    |  Optional  | Enables virtual network filtering for this Cosmos DB account.                                                                                                                                                                                                          | true , false                                                                                                 |
| ip_range_filter                   |  string   |  Optional  | CosmosDB Firewall Support: This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account. IP addresses/ranges must be comma separated and must not contain any spaces. |                                                                                                              |
| api_type                          |  string   |  Optional  | The capabilities which should be enabled for this Cosmos DB account.                                                                                                                                                                                                   | EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableTable, MongoDBv3.4 , mongoEnableDocLevelTTL |
| consistency_level                 |  string   |  Required  | The Consistency Level to use for this CosmosDB Account.                                                                                                                                                                                                                | BoundedStaleness, Eventual, Session, Strong , ConsistentPrefix                                               |
| max_interval_in_seconds           |  number   |  Optional  | When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated. Defaults to 5. Required when consistency_level is set to BoundedStaleness.                                                          | 5 - 86400 (1 day)                                                                                            |
| max_staleness_prefix              |  number   |  Optional  | When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated. Defaults to 100. Required when consistency_level is set to BoundedStaleness.                                                                     | 10 – 2147483647                                                                                              |
| failover_location                 |  string   |  Required  | The name of the Azure region to host replicated data.                                                                                                                                                                                                                  |                                                                                                              |

### **Optional Parameters**

#### cosmosdb_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional CosmosDB Account resources tags, in addition to the resource group tags.

    Default: {}

#### throughput `number`

    Description: The throughput of Mongo Collection/Cassandra Keyspace/Table (RU/s). Must be set in increments of 100. The minimum value is 400. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply.

    Default: 400

#### enable_logs_to_log_analytics `bool`

    Description: Boolean flag to specify whether the logs should be sent to Log Analytics.

    Default: false

#### log_analytics_workspace_id `string`

    Description: Specifies the Id of a Log Analytics Workspace where Diagnostics Data should be sent.

#### enable_logs_to_storage `bool`

    Description: Boolean flag to specify whether the logs should be sent to the Storage Account.

    Default: false

#### diagnostics_storage_account_name `string`

    Description: Specifies the name of the Storage Account where Diagnostics Data should be sent.

#### storage_account_ids_map `map(string)`

    Description: Map of Storage Account Id's.

## Outputs

#### cosmosdb_id

    Description: CosmosDB Account Id.

#### cosmosdb_endpoint

    Description: The endpoint used to connect to the CosmosDB Account.

#### primary_master_key

    Description: The Primary master key for the CosmosDB Account.

#### secondary_master_key

    Description: The Secondary master key for the CosmosDB Account.

#### mongo_api_id

    Description: The Cosmos DB Mongo Database Id.

#### table_api_id

    Description: The Cosmos DB Table Id.

#### cassandra_api_id

    Description: The Cosmos DB Cassandra KeySpace Id.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_cosmosdb_account](https://www.terraform.io/docs/providers/azurerm/r/cosmosdb_account.html) <br/>
[azurerm_cosmosdb_mongo_collection](https://www.terraform.io/docs/providers/azurerm/r/cosmosdb_mongo_collection.html) <br/>
[azurerm_cosmosdb_mongo_database](https://www.terraform.io/docs/providers/azurerm/r/cosmosdb_mongo_database.html) <br />
[azurerm_cosmosdb_cassandra_keyspace](https://www.terraform.io/docs/providers/azurerm/r/cosmosdb_cassandra_keyspace.html) <br/>
[azurerm_cosmosdb_table](https://www.terraform.io/docs/providers/azurerm/r/cosmosdb_table.html)
