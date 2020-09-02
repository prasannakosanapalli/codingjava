# Create Private Endpoints in Azure

This Module allows you to create and manage one or multiple Private Endpoints in Microsoft Azure.

## Features

This module will:

- Create one or multiple Private Endpoints in Microsoft Azure.
- Create Private DNS Zone for respective Private Endpoint.
- Create Private DNS Zone Virtual Network link within the Private DNS Zone for respective Private Endpoint.
- Create one or multiple DNS A Records within the Private DNS Zone for respective Private Endpoint.

## Usage

```hcl
module "PrivateEndpoint" {
  providers = {
    azurerm     = azurerm
    azuread     = azuread
    random      = random
    template    = template
    tls         = tls
    null        = null
    azurerm.ado = azurerm # Set this to azurerm.ado instead of azurerm if both ADO Agents and Application are in different subscription
  }
  source                  = "../../common-library/TerraformModules/PrivateEndpoint"
  private_endpoints       = var.private_endpoints
  resource_group_name     = module.BaseInfrastructure.resource_group_name
  key_vault_name          = module.BaseInfrastructure.key_vault_name
  subnet_ids              = module.BaseInfrastructure.map_subnet_ids
  vnet_ids                = module.BaseInfrastructure.map_vnet_ids
  resource_ids            = local.resource_ids
  ado_pe_kv_name          = var.ado_pe_kv_name
  ado_resource_group_name = var.ado_resource_group_name
  ado_vnet_name           = var.ado_vnet_name
  ado_subnet_name         = var.ado_subnet_name
  pe_additional_tags      = var.additional_tags
  dependencies            = [module.BaseInfrastructure.depended_on_kv]
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

    Description: Specifies the name of the resource group in which to create the Private Endpoint.

#### subnet_ids `map(string)`

    Description: Specifies the Map of subnet id's.

    Default: {}

#### vnet_ids `map(string)`

    Description: Specifies the Map of vnet id's.

    Default: {}

#### resource_ids `map(string)`

    Description: Specifies the Map of private link service resource id's.

    Default: {}

#### private_endpoints `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Private Endpoints.

    Default: {}

| Attribute            |    Data Type     | Field Type | Description                                                                                                                                                                                                                                                         | Allowed Values |
| :------------------- | :--------------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------- |
| name                 |      string      |  Required  | Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created.                                                                                                                                                                      |                |
| subnet_name          |      string      |  Required  | Specifies the name of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.                                                                                                    |                |
| resource_name        |      string      |  Required  | Specifies the name of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. Changing this forces a new resource to be created.                                                                                               |                |
| group_ids            |   list(string)   |  Optional  | A list of sub-resource names which the Private Endpoint is able to connect to. Changing this forces a new resource to be created.                                                                                                                                   |                |
| approval_required    |       bool       |  Optional  | Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.                                                                                                                                | true, false    |
| approval_message     |      string      |  Optional  | A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The request message can be a maximum of 140 characters in length. Only valid if **_approval_required_** is set to true. |                |
| dns_zone_name        |      string      |  Optional  | The name of the Private DNS Zone. Must be a valid domain name.                                                                                                                                                                                                      |                |
| zone_exists          |       bool       |  Optional  | Specifies if Private DNS Zone exists for this Private Endpoint or not.                                                                                                                                                                                              | true, false    |
| registration_enabled |       bool       |  Optional  | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to false.                                                                                                                                          | true, false    |
| vnet_links           | list(object({})) |  Required  | Specifies one or many `vnet_link` blocks as defined below.                                                                                                                                                                                                          |                |
| dns_a_records        | list(object({})) |  Optional  | Specifies a list of **_dns_a_record_** blocks as mentioned below.                                                                                                                                                                                                   |                |

#### vnet_link

| Attribute                | Data Type | Field Type | Description                                                                                                                         | Allowed Values |
| :----------------------- | :-------: | :--------: | :---------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| zone_to_vnet_link_name   |  string   |  Optional  | Specifies the custom name of the DNS Zone to Virtual Network link.                                                                  |                |
| vnet_name                |  string   |  Required  | Specifies the name of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created. |                |
| zone_to_vnet_link_exists |   bool    |  Optional  | Specifies if Private DNS Zone Virtual Network link exists for this Private DNS Zone or not.                                         | true, false    |

#### dns_a_record

| Attribute             |  Data Type   | Field Type | Description                                                                                                                                                                                     | Allowed Values |
| :-------------------- | :----------: | :--------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                  |    string    |  Required  | The name of the DNS A Record.                                                                                                                                                                   |                |
| ttl                   |    number    |  Optional  | The Time To Live (TTL) of the DNS record in seconds.                                                                                                                                            |                |
| ip_addresses          | list(string) |  Optional  | Specifies the list of IPv4 addresses. Required if **_private_endpoint_name_** is not set. If not specified Private Endpoint NIC IP Addresses associated to corresponding DNS Zone will be used. |                |
| private_endpoint_name |    string    |  Optional  | Specifies the Name of Private Endpoint for which DNS A Record is to be created. Required if **_ip_addresses_** is not set.                                                                      |                |

#### ado_private_endpoints `map(object({}))`

    Description: Specifies the Map of objects containing attributes for ADO Private Endpoints.

    Default: {}

| Attribute     |  Data Type   | Field Type | Description                                                                                                                                                           | Allowed Values |
| :------------ | :----------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name          |    string    |  Required  | Specifies the Name of the ADO Private Endpoint. Changing this forces a new resource to be created.                                                                    |                |
| resource_name |    string    |  Required  | Specifies the name of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. Changing this forces a new resource to be created. |                |
| group_ids     | list(string) |  Optional  | A list of sub-resource names which the Private Endpoint is able to connect to. Changing this forces a new resource to be created.                                     |                |
| dns_zone_name |    string    |  Optional  | The name of the existing Private DNS Zone in ADO RG. Must be a valid domain name.                                                                                     |                |

#### ado_resource_group_name `string`

    Description: Specifies the existing ado agent resource group name.

#### ado_vnet_name `string`

    Description: Specifies the existing ado agent virtual network name.

#### ado_subnet_name `string`

    Description: Specifies the existing ado agent subnet name.

#### dependencies `list(any)`

    Description: Specifies the modules that the Private Endpoint Resource depends on.

    Default: []

### **Optional Parameters**

#### pe_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Private Endpoint resources tags, in addition to the resource group tags.

    Default: {}

## Outputs

#### private_endpoint_ids

    Description: The list of Private Endpoint Id's.

#### private_ip_addresses

    Description: The list of Private Endpoint IP Addresses.

#### dns_zone_ids

    Description: The list of Prviate DNS Zone Id's.

#### dns_zone_vnet_link_ids

    Description: The list of Private DNS Zone Virtual Network Link resource Id's.

#### dns_a_record_fqdn_map

    Description: The Map of FQDN of the DNS A Records.

#### dns_a_record_ids_map

    Description: The Map of Id of the DNS A Records.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_private_endpoint](https://www.terraform.io/docs/providers/azurerm/r/private_endpoint.html) <br />
[azurerm_private_dns_zone](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html) <br />
[azurerm_private_dns_zone_virtual_network_link](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone_virtual_network_link.html) <br />
[azurerm_private_dns_a_record](https://www.terraform.io/docs/providers/azurerm/r/private_dns_a_record.html)
