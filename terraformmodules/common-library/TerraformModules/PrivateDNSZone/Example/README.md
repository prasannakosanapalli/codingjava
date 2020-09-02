# Create Private DNS Zones in Azure

This Module allows you to create and manage one or multiple Private DNS Zones in Microsoft Azure.

## Features

This module will:

- Create one or multiple Private DNS Zones in Azure.
- Create Private DNS Zone Virtual Network link within the Private DNS Zone.

## Usage

```hcl
module "PrivateDNSZone" {
  source                   = "../../common-library/TerraformModules/PrivateDNSZone"
  private_dns_zones        = var.private_dns_zones
  resource_group_name      = module.BaseInfrastructure.resource_group_name
  vnet_ids                 = module.BaseInfrastructure.map_vnet_ids
  dns_zone_additional_tags = var.additional_tags
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

    Description: Specifies the name of the resource group in which to create the Private DNS Zone.

#### vnet_ids `map(string)`

    Description: Specifies the Map of vnet id's.

    Default: {}

#### private_dns_zones `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Private DNS Zones.

    Default: {}

| Attribute            |    Data Type     | Field Type | Description                                                                                                                                   | Allowed Values |
| :------------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| dns_zone_name        |      string      |  Required  | The name of the Private DNS zone (without a terminating dot). Changing this forces a new resource to be created. Must be a valid domain name. |                |
| vnet_links           | list(object({})) |  Required  | Specifies one or many `vnet_link` blocks as defined below.                                                                                    |                |
| zone_exists          |       bool       |  Optional  | Specifies if Private DNS Zone exists or not.                                                                                                  | true, false    |
| registration_enabled |       bool       |  Optional  | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to false.                    | true, false    |

#### vnet_link

| Attribute                | Data Type | Field Type | Description                                                                                                                         | Allowed Values |
| :----------------------- | :-------: | :--------: | :---------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| zone_to_vnet_link_name   |  string   |  Optional  | Specifies the custom name of the DNS Zone to Virtual Network link.                                                                  |                |
| vnet_name                |  string   |  Required  | Specifies the name of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created. |                |
| zone_to_vnet_link_exists |   bool    |  Optional  | Specifies if Private DNS Zone Virtual Network link exists for this Private DNS Zone or not.                                         | true, false    |

### **Optional Parameters**

#### dns_zone_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Private DNS Zone resources tags, in addition to the resource group tags.

    Default: {}

## Outputs

#### dns_zone_ids

    Description: The list of Prviate DNS Zone Id's.

#### dns_zone_vnet_link_ids

    Description: The list of Private DNS Zone Virtual Network Link resource Id's.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_private_dns_zone](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html) <br />
[azurerm_private_dns_zone_virtual_network_link](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone_virtual_network_link.html)
