# Create Private DNS Records in Azure

This Module allows you to create and manage one or multiple Private DNS Records in Microsoft Azure.

## Features

This module will:

- Create one or multiple DNS A Records within the Private DNS Zone.

## Usage

```hcl
module "PrivateDNSARecord" {
  source                        = "../../common-library/TerraformModules/PrivateDNSARecord"
  dns_a_records                 = var.dns_a_records
  resource_group_name           = module.BaseInfrastructure.resource_group_name
  dns_arecord_additional_tags   = var.additional_tags
  private_endpoint_ip_addresses = module.PrivateEndpoint.private_ip_addresses_map
  a_records_depends_on          = module.PrivateDNSZone
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

    Description: Specifies the name of the resource group in which to create the Private DNS A Record.

#### private_endpoint_ip_addresses `map(string)`

    Description: Specifies the Map of Private Endpoint IP Addresses.

    Default: {}

#### dns_a_records `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Private DNS A Records.

    Default: {}

| Attribute             |  Data Type   | Field Type | Description                                                                                                                | Allowed Values |
| :-------------------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------- | :------------- |
| a_record_name         |    string    |  Required  | The name of the DNS A Record.                                                                                              |                |
| dns_zone_name         |    string    |  Required  | Specifies the Private DNS Zone where the resource exists. Changing this forces a new resource to be created.               |                |
| ttl                   |    number    |  Optional  | Specifies the Time To Live (TTL) of the DNS record in seconds.                                                             |                |
| ip_addresses          | list(string) |  Optional  | Specifies the list of IPv4 addresses. Required if **_private_endpoint_name_** is not set.                                  |                |
| private_endpoint_name |    string    |  Optional  | Specifies the Name of Private Endpoint for which DNS A Record is to be created. Required if **_ip_addresses_** is not set. |                |

### **Optional Parameters**

#### dns_arecord_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Private DNS A Record resources tags, in addition to the resource group tags.

    Default: {}

#### a_records_depends_on `any`

    Description: Specifies the DNS Zone Module Resource on which this module depends on.

    Default: null

## Outputs

#### dns_a_record_fqdn_map

    Description: The Map of FQDN of the DNS A Records.

#### dns_a_record_ids_map

    Description: The Map of Id of the DNS A Records.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_private_dns_a_record](https://www.terraform.io/docs/providers/azurerm/r/private_dns_a_record.html)
