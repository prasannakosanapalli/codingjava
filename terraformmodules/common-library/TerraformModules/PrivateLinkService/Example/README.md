# Create Private Link Services in Azure

This Module allows you to create and manage one or multiple Private Link Services in Microsoft Azure.

## Features

This module will:

- Create one or multiple Private Link Services in Microsoft Azure.

## Usage

```hcl
module "PrivateLinkService" {
  source                         = "../../common-library/TerraformModules/PrivateLinkService"
  resource_group_name            = module.BaseInfrastructure.resource_group_name
  private_link_services          = var.private_link_services
  subnet_ids                     = module.BaseInfrastructure.map_subnet_ids
  frontend_ip_configurations_map = module.LoadBalancer.frontend_ip_configurations_map
  pls_additional_tags            = var.additional_tags
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

    Description: Specifies the name of this Private Link Service. Changing this forces a new resource to be created.

#### subnet_ids `map(string)`

    Description: Specifies the Map of subnet id's.

#### frontend_ip_configurations_map `map(string)`

    Description: Specifies the Map of load balancer frontend ip configurations.

#### private_link_services `map(object({}))`

    Description: Specifies the Map of objects containing attributes for private link services.

| Attribute                      |  Data Type   | Field Type | Description                                                                                                                |
| :----------------------------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------- |
| name                           |    string    |  Required  | Specifies the name of this Private Link Service                                                                            |
| subnet_name                    |    string    |  Required  | Specifies the name of the Subnet which should be used for the Private Link Service                                         |
| frontend_ip_config_name        |    string    |  Required  | Frontend IP Configuration name from a Standard Load Balancer, where traffic from the Private Link Service should be routed |
| private_ip_address             |    string    |  Optional  | Specifies a Private Static IP Address for this IP Configuration                                                            |
| private_ip_address_version     |    string    |  Optional  | The version of the IP Protocol which should be used                                                                        |
| visibility_subscription_ids    | list(string) |  Optional  | A list of Subscription UUID/GUID's that will be able to see this Private Link Service                                      |
| auto_approval_subscription_ids | list(string) |  Optional  | A list of Subscription UUID/GUID's that will be automatically be able to use this Private Link Service                     |

### **Optional Parameters**

#### pls_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource.

    Default: {}

## Outputs

#### pls_ids

    Description: The Private Link Service Id's.

#### pls_dns_names

    Description: The globally unique DNS Name for the Private Link Services. You can use this alias to request a connection to the Private Link Services.

#### private_link_service_map_ids

    Description: The Map of Private Link Service Id's.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_private_link_service](https://www.terraform.io/docs/providers/azurerm/r/private_link_service.html)
