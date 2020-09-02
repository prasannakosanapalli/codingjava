# Create Azure Container Registry in Azure

This Module allows you to create and manage Azure Container Registry in Microsoft Azure.

## Features

This module will:

- Create Azure Container Registry in Microsoft Azure.

## Usage

```hcl
module "AzureContainerRegistry" {
  source                   = "../../common-library/TerraformModules/AzureContainerRegistry"
  resource_group_name      = module.BaseInfrastructure.resource_group_name
  name                     = var.name
  sku                      = var.sku
  georeplication_locations = var.georeplication_locations
  admin_enabled            = var.admin_enabled
  allowed_subnet_ids       = var.allowed_subnet_ids
  acr_additional_tags      = var.additional_tags
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

    Description: Specifies the name of the resource group in which to create the Azure Container Registry.

#### name `string`

    Description: Specifies the name of the Container Registry. Changing this forces a new resource to be created.

### **Optional Parameters**

#### acr_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Azure Container Registry resource tags, in addition to the resource group tags.

    Default: {}

#### sku `string`

    Description: The SKU name of the container registry. Possible values are Basic, Standard and Premium.

    Default: "Premium"

#### admin_enabled `bool`

    Description: Specifies whether the admin user is enabled. Defaults to false.

    Default: false

#### georeplication_locations `list(string)`

    Description: A list of Azure locations where the container registry should be geo-replicated.

#### allowed_subnet_ids `list(string)`

    Description: Specifies the list of subnet id's from which requests will match the network rule.

## Outputs

#### acr_id `string`

    Description: The Container Registry ID.

#### acr_name `string`

    Description: The Container Registry name.

#### login_server `string`

    Description: The URL that can be used to log into the container registry.

#### acr_fqdn `string`

    Description: The Container Registry FQDN.

#### admin_username `string`

    Description: The Username associated with the Container Registry Admin account - if the admin account is enabled.

#### admin_password `string`

    Description: The Password associated with the Container Registry Admin account - if the admin account is enabled.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_container_registry](https://www.terraform.io/docs/providers/azurerm/r/container_registry.html)
