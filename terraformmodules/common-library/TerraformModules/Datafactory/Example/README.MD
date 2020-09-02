# Create DataFactory module in Azure

This Module allows you to create and manage DataFactory in Microsoft Azure.

## Features

This module will:

- Create Datafactory in Microsoft Azure.

## Usage

```hcl
module "Datafactory" {
  source                   = "../../common-library/TerraformModules/Datafactory"
  resource_group_name      = var.resource_group_name
  data_factory             = var.data_factory
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the DataFactory module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the DataFactory module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the DataFactory module.

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

#### data_factory `map(object({}))`

| Attribute                         | Data Type | Field Type | Description                                                                                                                                                                                                                                                            | Allowed Values                                                                                               |
| :-------------------------------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------- |
| name                     |  string   |  Required  | Name of the Data Factory. Changing this forces a new resource to be created.                                                                                                                                                                         |                                                                                                              |
| assign_identity                     |  bool   |  Required  | Enable MSI Identity on Data Factory |                                                                                                              |

#### vsts_configuration `object({})`

| Attribute                         | Data Type | Field Type | Description                                                                                                                                                                                                                                                            | Allowed Values                                                                                               |
| :-------------------------------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------- |
| account_name                |  string   |  Required  | Specifies the VSTS account name.        |                                                                                                              |
| branch_name                 |  string   |  Required  | Specifies the branch of the repository to get code from.       |                                                                                                              |
| project_name                |  string   |  Required  | Specifies the name of the VSTS project.       |                                                                                                              |
| repository_name             |  string   |  Required  | Specifies the name of the git repository.       |                                                                                                              |
| root_folder                 |  string   |  Required  | Specifies the root folder within the repository. Set to / for the top level.      |                                                                                                              |
| tenant_id                   |  string   |  Required  | Specifies the Tenant ID associated with the VSTS account. |                                                                                                              |



## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_data_factory](https://www.terraform.io/docs/providers/azurerm/r/data_factory.html) <br/>

