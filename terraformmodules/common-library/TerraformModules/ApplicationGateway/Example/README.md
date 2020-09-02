# Create Application Gateways in Azure

This Module allows you to create and manage one or multiple Application Gateways in Microsoft Azure.

## Features

This module will:

- Create one or multiple Application Gateways in Microsoft Azure.

## Usage

```hcl
module "ApplicationGateway" {
  providers = {
    azurerm     = azurerm
    azurerm.ado = azurerm # Set this to azurerm.ado instead of azurerm if both ADO Agents and Application are in different subscription
  }
  source                           = "../../common-library/TerraformModules/ApplicationGateway"
  resource_group_name              = module.BaseInfrastructure.resource_group_name
  subnet_ids                       = module.BaseInfrastructure.map_subnet_ids
  storage_account_ids_map          = module.BaseInfrastructure.sa_ids_map
  log_analytics_workspace_id       = module.BaseInfrastructure.law_id
  app_gateway_additional_tags      = var.additional_tags
  key_vault_resource_group         = var.key_vault_resource_group
  key_vault_name                   = var.key_vault_name
  application_gateways             = var.application_gateways
  waf_policies                     = var.waf_policies
  diagnostics_storage_account_name = var.diagnostics_storage_account_name
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

    Description: Specifies the name of the resource group in which to create the Application Gateways.

#### subnet_ids `map(string)`

    Description: Specifies the Map of subnet id's.

    Default: {}

#### key_vault_resource_group `string`

    Description: Specifies the Name of Resource Group in which the soucre Key Vault for SSL PFX Certificate exists.

#### key_vault_name `string`

    Description: Specifies the Name of Key Vault in which the Key Vault Secret for SSL PFX Certificate exists.

                 Add a Key Vault Access Policy for the Pipeline Service Application running the Pipeline to get the SSL Certificate stored in Key Vault Secret.

#### log_analytics_workspace_id `string`

    Description: Specifies the Id of a Log Analytics Workspace where Diagnostics Data should be sent.

#### diagnostics_storage_account_name `string`

    Description: Specifies the name of the Storage Account where Diagnostics Data should be sent.

#### storage_account_ids_map `map(string)`

    Description: Map of Storage Account Id's.

#### application_gateways `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Application Gateways.

| Attribute                               |    Data Type     | Field Type | Description                                                                                                                                                                       | Allowed Values               |
| :-------------------------------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------- |
| name                                    |      string      |  Required  | Specifies the name of the Application Gateway. Changing this forces a new resource to be created.                                                                                 |                              |
| zones                                   |   list(string)   |  Optional  | A collection of availability zones to spread the Application Gateway over.                                                                                                        |                              |
| waf_key                                 |      string      |  Optional  | Specifies the Map key from the **_waf_policies_** web application firewall policies blocks which is associated to this Application Gateway.                                       |                              |
| sku                                     |    object({})    |  Optional  | Specifies the **_sku_** block as defined below.                                                                                                                                   |                              |
| enable_http2                            |       bool       |  Optional  | Is HTTP2 enabled on the application gateway resource? Defaults to false.                                                                                                          | true, false                  |
| gateway_ip_configurations               | list(object({})) |  Required  | Specifies one or more **_gateway_ip_configuration_** blocks as defined below.                                                                                                     |                              |
| frontend_ports                          | list(object({})) |  Required  | Specifies one or more **_frontend_port_** blocks as defined below.                                                                                                                |                              |
| frontend_ip_configurations              | list(object({})) |  Required  | Specifies one or more **_frontend_ip_configuration_** blocks as defined below.                                                                                                    |
| backend_address_pools                   | list(object({})) |  Required  | Specifies one or more **_backend_address_pool_** blocks as defined below.                                                                                                         |                              |
| backend_http_settings                   | list(object({})) |  Required  | Specifies one or more **_backend_http_setting_** blocks as defined below.                                                                                                         |                              |
| http_listeners                          | list(object({})) |  Required  | Specifies one or more **_http_listener_** blocks as defined below.                                                                                                                |                              |
| request_routing_rules                   | list(object({})) |  Required  | Specifies one or more **_request_routing_rule_** blocks as defined below.                                                                                                         |                              |
| redirect_configurations                 | list(object({})) |  Optional  | Specifies one or more **_redirect_configuration_** blocks as defined below.                                                                                                       |                              |
| url_path_maps                           | list(object({})) |  Optional  | Specifies one or more **_url_path_map_** blocks as defined below.                                                                                                                 |                              |
| probes                                  | list(object({})) |  Optional  | Specifies one or more **_probe_** blocks as defined below.                                                                                                                        |                              |
| rewrite_rule_sets                       | list(object({})) |  Optional  | One or more **_rewrite_rule_set_** blocks as defined below. Only valid for v2 SKUs.                                                                                               |                              |
| trusted_root_certificate_names          |   list(string)   |  Optional  | Specifies a list of **_trusted_root_certificate_** names.                                                                                                                         |                              |
| ssl_certificate_names                   |   list(string)   |  Optional  | Specifies a list of ssl certificate names which should be used for HTTP Listener's.                                                                                               |                              |
| disabled_ssl_protocols                  |   list(string)   |  Optional  | A list of SSL Protocols which should be disabled on this Application Gateway.                                                                                                     | TLSv1_0, TLSv1_1 and TLSv1_2 |
| key_vault_with_private_endpoint_enabled |       bool       |  Optional  | Set this to **_true_** if the network firewall is set to `Private endpoint and selected networks` for Key Vault where the .PFX or .CER certificates are stored. Defaults to true. | true, false                  |

#### sku

| Attribute | Data Type | Field Type | Description                                                                                                                                      | Allowed Values                                                                                  |
| :-------- | :-------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------- |
| name      |  string   |  Required  | The Name of the SKU to use for this Application Gateway.                                                                                         | Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2 |
| tier      |  string   |  Required  | The Tier of the SKU to use for this Application Gateway.                                                                                         | Standard, Standard_v2, WAF and WAF_v2                                                           |
| capacity  |  number   |  Required  | The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. |                                                                                                 |

#### gateway_ip_configuration

| Attribute   | Data Type | Field Type | Description                                | Allowed Values |
| :---------- | :-------: | :--------: | :----------------------------------------- | :------------- |
| name        |  string   |  Required  | The Name of this Gateway IP Configuration. |                |
| subnet_name |  string   |  Required  | The Name of the Subnet.                    |                |

#### frontend_port

| Attribute | Data Type | Field Type | Description                           | Allowed Values |
| :-------- | :-------: | :--------: | :------------------------------------ | :------------- |
| name      |  string   |  Required  | The name of the Frontend Port.        |                |
| port      |  number   |  Required  | The port used for this Frontend Port. |                |

#### frontend_ip_configuration

| Attribute        | Data Type | Field Type | Description                                                                                                 | Allowed Values |
| :--------------- | :-------: | :--------: | :---------------------------------------------------------------------------------------------------------- | :------------- |
| name             |  string   |  Required  | The name of the Frontend IP Configuration.                                                                  |                |
| subnet_name      |  string   |  Required  | The ID of the Subnet which the Application Gateway should be connected to.                                  |                |
| static_ip        |  string   |  Optional  | The Private IP Address to use for the Application Gateway.                                                  |                |
| enable_public_ip |   bool    |  Optional  | Specifies whether to create and set the Id of a Public IP Address which the Application Gateway should use. | true, false    |

#### backend_address_pool

| Attribute    |  Data Type   | Field Type | Description                                                              | Allowed Values |
| :----------- | :----------: | :--------: | :----------------------------------------------------------------------- | :------------- |
| name         |    string    |  Required  | The name of the Backend Address Pool.                                    |                |
| fqdns        | list(string) |  Optional  | A list of FQDN's which should be part of the Backend Address Pool.       |                |
| ip_addresses | list(string) |  Optional  | A list of IP Addresses which should be part of the Backend Address Pool. |                |

#### backend_http_setting

| Attribute                           | Data Type | Field Type | Description                                                                                                               | Allowed Values              |
| :---------------------------------- | :-------: | :--------: | :------------------------------------------------------------------------------------------------------------------------ | :-------------------------- |
| name                                |  string   |  Required  | The name of the Backend HTTP Settings Collection.                                                                         |                             |
| cookie_based_affinity               |  string   |  Required  | Is Cookie-Based Affinity enabled?                                                                                         | Enabled or Disabled         |
| path                                |  string   |  Optional  | The Path which should be used as a prefix for all HTTP requests.                                                          |                             |
| port                                |  number   |  Required  | The port which should be used for this Backend HTTP Settings Collection.                                                  |                             |
| protocol                            |  string   |  Required  | The Protocol which should be used. Defaults to Https.                                                                     | Http or Https               |
| request_timeout                     |  number   |  Required  | The request timeout in seconds.                                                                                           | between 1 and 86400 seconds |
| probe_name                          |  string   |  Optional  | The name of an associated HTTP Probe.                                                                                     |                             |
| host_name                           |  string   |  Optional  | Host header to be sent to the backend servers. Cannot be set if **_pick_host_name_from_backend_address_** is set to true. |                             |
| pick_host_name_from_backend_address |   bool    |  Optional  | Whether host header should be picked from the host name of the backend server. Defaults to false.                         | true, false                 |

#### http_listener

| Attribute                      |  Data Type   | Field Type | Description                                                                                                                                       | Allowed Values     |
| :----------------------------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------ | :----------------- |
| name                           |    string    |  Required  | The Name of the HTTP Listener.                                                                                                                    |                    |
| frontend_ip_configuration_name |    string    |  Required  | The Name of the Frontend IP Configuration used for this HTTP Listener.                                                                            |                    |
| frontend_port_name             |    string    |  Required  | The Name of the Frontend Port use for this HTTP Listener.                                                                                         |                    |
| ssl_certificate_name           |    string    |  Optional  | The name of the associated SSL Certificate which should be used for this HTTP Listener.                                                           |                    |
| sni_required                   |     bool     |  Optional  | Should Server Name Indication be Required? Defaults to false.                                                                                     | true, false        |
| listener_type                  |    string    |   string   | Specifies the http listener type.                                                                                                                 | Basic or MultiSite |
| host_name                      |    string    |  Optional  | The Hostname which should be used for this HTTP Listener. Required if **_listener_type = "MultiSite"_**                                           |
| host_names                     | list(string) |  Optional  | A list of Hostname(s) should be used for this HTTP Listener. It allows special wildcard characters. Required if **_listener_type = "MultiSite"_** |
| protocol                       |    string    |  Required  | The Protocol to use for this HTTP Listener. Defaults to Https.                                                                                    | Http or Https      |

### `NOTE: The host_names and host_name are mutually exclusive and cannot both be set.`

#### request_routing_rule

| Attribute                   | Data Type | Field Type | Description                                                                                                                                                                            | Allowed Values            |
| :-------------------------- | :-------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------ |
| name                        |  string   |  Required  | The Name of this Request Routing Rule.                                                                                                                                                 |                           |
| rule_type                   |  string   |  Required  | The Type of Routing that should be used for this Rule.                                                                                                                                 | Basic or PathBasedRouting |
| listener_name               |  string   |  Required  | The Name of the HTTP Listener which should be used for this Routing Rule.                                                                                                              |                           |
| backend_address_pool_name   |  string   |  Optional  | The Name of the Backend Address Pool which should be used for this Routing Rule. Cannot be set if **_redirect_configuration_name_** is set.                                            |                           |
| backend_http_settings_name  |  string   |  Optional  | The Name of the Backend HTTP Settings Collection which should be used for this Routing Rule. Cannot be set if **_redirect_configuration_name_** is set.                                |                           |
| redirect_configuration_name |  string   |  Optional  | The Name of the Redirect Configuration which should be used for this Routing Rule. Cannot be set if **_either backend_address_pool_name_** or **_backend_http_settings_name_** is set. |                           |
| url_path_map_name           |  string   |  Optional  | The Name of the URL Path Map which should be associated with this Routing Rule.                                                                                                        |                           |
| rewrite_rule_set_name       |  string   |  Optional  | The Name of the Rewrite Rule Set which should be used for this Routing Rule. Only valid for v2 SKUs.                                                                                   |                           |

#### redirect_configuration

| Attribute            | Data Type | Field Type | Description                                                                             | Allowed Values                           |
| :------------------- | :-------: | :--------: | :-------------------------------------------------------------------------------------- | :--------------------------------------- |
| name                 |  string   |  Required  | Unique name of the redirect configuration block.                                        |                                          |
| redirect_type        |  string   |  Required  | The type of redirect.                                                                   | Permanent, Temporary, Found and SeeOther |
| target_listener_name |  string   |  Optional  | The name of the listener to redirect to. Cannot be set if **_target_url_** is set.      |                                          |
| target_url           |  string   |  Optional  | The Url to redirect the request to. Cannot be set if **_target_listener_name_** is set. |                                          |
| include_path         |   bool    |  Optional  | Whether or not to include the path in the redirected Url. Defaults to false.            | true, false                              |
| include_query_string |   bool    |  Optional  | Whether or not to include the query string in the redirected Url. Default to false.     | true, false                              |

#### url_path_map

| Attribute                           |    Data Type     | Field Type | Description                                                                                                                                                                                                    | Allowed Values |
| :---------------------------------- | :--------------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                                |      string      |  Required  | The Name of the URL Path Map.                                                                                                                                                                                  |                |
| default_backend_http_settings_name  |      string      |  Optional  | The Name of the Default Backend HTTP Settings Collection which should be used for this URL Path Map. Cannot be set if **_default_redirect_configuration_name_** is set.                                        |                |
| default_backend_address_pool_name   |      string      |  Optional  | The Name of the Default Backend Address Pool which should be used for this URL Path Map. Cannot be set if **_default_redirect_configuration_name_** is set.                                                    |                |
| default_redirect_configuration_name |      string      |  Optional  | The Name of the Default Redirect Configuration which should be used for this URL Path Map. Cannot be set if either **_default_backend_address_pool_name_** or **_default_backend_http_settings_name_** is set. |
| path_rules                          | list(object({})) |  Required  | Specifies one or more **_path_rule_** blocks as defined below.                                                                                                                                                 |                |
| default_rewrite_rule_set_name       |      string      |  Optional  | The Name of the Default Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs.                                                                                                   |                |

#### path_rule

| Attribute                   |  Data Type   | Field Type | Description                                                                                                                                                  | Allowed Values |
| :-------------------------- | :----------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                        |    string    |  Required  | The Name of the Path Rule.                                                                                                                                   |                |
| paths                       | list(string) |  Required  | A list of Paths used in this Path Rule.                                                                                                                      |                |
| backend_http_settings_name  |    string    |  Optional  | The Name of the Backend HTTP Settings Collection to use for this Path Rule. Cannot be set if **_redirect_configuration_name_** is set.                       |                |
| backend_address_pool_name   |    string    |  Optional  | The Name of the Backend Address Pool to use for this Path Rule. Cannot be set if **_redirect_configuration_name_** is set.                                   |                |
| redirect_configuration_name |    string    |  Optional  | The Name of a Redirect Configuration to use for this Path Rule. Cannot be set if **_backend_address_pool_name_** or **_backend_http_settings_name_** is set. |                |
| rewrite_rule_set_name       |    string    |  Optional  | The Name of the Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs.                                                         |                |

#### probe

| Attribute                                 | Data Type | Field Type | Description                                                                                                                                                                                                                                                                              | Allowed Values                                     |
| :---------------------------------------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------- |
| name                                      |  string   |  Required  | The Name of the Probe.                                                                                                                                                                                                                                                                   |                                                    |
| protocol                                  |  string   |  Required  | The Protocol used for this Probe. Defaults to Https.                                                                                                                                                                                                                                     | Http or Https                                      |
| path                                      |  string   |  Required  | The Path used for this Probe.                                                                                                                                                                                                                                                            |                                                    |
| host                                      |  string   |  Optional  | The Hostname used for this Probe. If the Application Gateway is configured for a single site, by default the Host name should be specified as ‘127.0.0.1’, unless otherwise configured in custom probe. Cannot be set if **_pick_host_name_from_backend_http_settings_** is set to true. |                                                    |
| interval                                  |  number   |  Required  | The Interval between two consecutive probes in seconds.                                                                                                                                                                                                                                  | range from 1 second to a maximum of 86,400 seconds |
| timeout                                   |  string   |  Required  | The Timeout used for this Probe, which indicates when a probe becomes unhealthy.                                                                                                                                                                                                         | range from 1 second to a maximum of 86,400 seconds |
| unhealthy_threshold                       |  number   |  Required  | The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy.                                                                                                                                               | 1 - 20 seconds                                     |
| pick_host_name_from_backend_http_settings |   bool    |  Optional  | Whether the host header should be picked from the backend http settings. Defaults to false.                                                                                                                                                                                              | true, false                                        |

#### rewrite_rule_set

| Attribute     |    Data Type     | Field Type | Description                                             | Allowed Values |
| :------------ | :--------------: | :--------: | :------------------------------------------------------ | :------------- |
| name          |      string      |  Required  | Unique name of the rewrite rule set block               |                |
| rewrite_rules | list(object({})) |  Required  | One or more **_rewrite_rule_** blocks as defined above. |                |

#### rewrite_rule

| Attribute                      |    Data Type     | Field Type | Description                                                                        | Allowed Values |
| :----------------------------- | :--------------: | :--------: | :--------------------------------------------------------------------------------- | :------------- |
| name                           |      string      |  Required  | Unique name of the rewrite rule block                                              |                |
| rule_sequence                  |      number      |  Required  | Rule sequence of the rewrite rule that determines the order of execution in a set. |                |
| conditions                     | list(object({})) |  Optional  | One or more **_condition_** blocks as defined above.                               |                |
| request_header_configurations  | list(object({})) |  Optional  | One or more **_request_header_configuration_** blocks as defined above.            |                |
| response_header_configurations | list(object({})) |  Optional  | One or more **_response_header_configuration_** blocks as defined above.           |                |

#### condition

| Attribute   | Data Type | Field Type | Description                                                                                               | Allowed Values |
| :---------- | :-------: | :--------: | :-------------------------------------------------------------------------------------------------------- | :------------- |
| variable    |  string   |  Required  | Application Gateway uses server variables to store useful information about the server.                   |                |
| pattern     |  string   |  Required  | The pattern, either fixed string or regular expression, that evaluates the truthfulness of the condition. |                |
| ignore_case |   bool    |  Optional  | Perform a case in-sensitive comparison. Defaults to false                                                 | true, false    |
| negate      |   bool    |  Optional  | Negate the result of the condition evaluation. Defaults to false                                          | true, false    |

#### request_header_configurations

| Attribute    | Data Type | Field Type | Description                                                                                                | Allowed Values |
| :----------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------- | :------------- |
| header_name  |  string   |  Required  | Header name of the header configuration.                                                                   |                |
| header_value |  string   |  Required  | Header value of the header configuration. To delete a request header set this property to an empty string. |                |

#### response_header_configurations

| Attribute    | Data Type | Field Type | Description                                                                                                 | Allowed Values |
| :----------- | :-------: | :--------: | :---------------------------------------------------------------------------------------------------------- | :------------- |
| header_name  |  string   |  Required  | Header name of the header configuration.                                                                    |                |
| header_value |  string   |  Required  | Header value of the header configuration. To delete a response header set this property to an empty string. |                |

### **Optional Parameters**

#### app_gateway_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Application Gateways resources tags, in addition to the resource group tags.

    Default: {}

#### waf_policies `map(object({}))`

| Attribute       |    Data Type     | Field Type | Description                                                                | Allowed Values |
| :-------------- | :--------------: | :--------: | :------------------------------------------------------------------------- | :------------- |
| name            |      string      |  Required  | The name of the policy. Changing this forces a new resource to be created. |                |
| custom_rules    | list(object({})) |  Optional  | Specifies one or more **_custom_rule_** blocks as defined below.           |                |
| policy_settings |    object({})    |  Optional  | A **_policy_settings_** block as defined below.                            |                |
| managed_rules   |    object({})    |  Optional  | A **_managed_rules_** block as defined below.                              |                |

#### custom_rule

| Attribute        |    Data Type     | Field Type | Description                                                                                                      | Allowed Values |
| :--------------- | :--------------: | :--------: | :--------------------------------------------------------------------------------------------------------------- | :------------- |
| name             |      string      |  Optional  | Specifies the name of the resource that is unique within a policy. This name can be used to access the resource. |                |
| priority         |      string      |  Required  | Specifies the priority of the rule. Rules with a lower value will be evaluated before rules with a higher value. |                |
| rule_type        |      string      |  Required  | Specifies the type of rule.                                                                                      |                |
| action           |      string      |  Required  | Type of action.                                                                                                  |                |
| match_conditions | list(object({})) |  Required  | Specifies one or more **_match_condition_** blocks as defined below.                                             |                |

#### match_condition

| Attribute          |    Data Type     | Field Type | Description                                                         | Allowed Values |
| :----------------- | :--------------: | :--------: | :------------------------------------------------------------------ | :------------- |
| match_variables    | list(object({})) |  Required  | Specifies one or more **_match_variable_** blocks as defined below. |                |
| operator           |      string      |  Required  | Specifies the operator to be matched.                               |                |
| negation_condition |       bool       |  Optional  | Describes if this is negate condition or not                        |                |
| match_values       |   list(string)   |  Required  | A list of match values.                                             |                |

#### match_variable

| Attribute     | Data Type | Field Type | Description                                      | Allowed Values |
| :------------ | :-------: | :--------: | :----------------------------------------------- | :------------- |
| variable_name |  string   |  Required  | The name of the Match Variable.                  |                |
| selector      |  string   |  Optional  | Describes field of the matchVariable collection. |                |

#### policy_settings

| Attribute | Data Type | Field Type | Description                                                                                          | Allowed Values |
| :-------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------- | :------------- |
| enabled   |   bool    |  Optional  | Describes if the policy is in enabled state or disabled state Defaults to Enabled.                   |                |
| mode      |  string   |  Optional  | Describes if it is in detection mode or prevention mode at the policy level. Defaults to Prevention. |                |

#### managed_rules

| Attribute         |    Data Type     | Field Type | Description                                                       | Allowed Values |
| :---------------- | :--------------: | :--------: | :---------------------------------------------------------------- | :------------- |
| exclusions        | list(object({})) |  Optional  | Specifies one or more **_exclusion_** block defined below.        |                |
| managed_rule_sets | list(object({})) |  Optional  | Specifies one or more **_managed_rule_set_** block defined below. |                |

#### exclusion

| Attribute               | Data Type | Field Type | Description                                      | Allowed Values                                          |
| :---------------------- | :-------: | :--------: | :----------------------------------------------- | :------------------------------------------------------ |
| match_variable          |  string   |  Required  | The name of the Match Variable.                  | RequestArgNames, RequestCookieNames, RequestHeaderNames |
| selector                |  string   |  Optional  | Describes field of the matchVariable collection. |                                                         |
| selector_match_operator |  string   |  Required  | Describes operator to be matched.                | Contains, EndsWith, Equals, EqualsAny, StartsWith       |

#### managed_rule_set

| Attribute            |    Data Type     | Field Type | Description                                                          | Allowed Values |
| :------------------- | :--------------: | :--------: | :------------------------------------------------------------------- | :------------- |
| type                 |      string      |  Optional  | The rule set type.                                                   |                |
| version              |      string      |  Required  | The rule set version.                                                |                |
| rule_group_overrides | list(object({})) |  Optional  | Specifies one or more **_rule_group_override_** block defined below. |                |

#### rule_group_override

| Attribute       |  Data Type   | Field Type | Description                      | Allowed Values |
| :-------------- | :----------: | :--------: | :------------------------------- | :------------- |
| rule_group_name |    string    |  Required  | The name of the Rule Group.      |                |
| disabled_rules  | list(string) |  Optional  | Specifies one or more Rule Id's. |                |

## Outputs

#### application_gateway_ids `list(string)`

    Description: Specifies the list of Application Gateway Id's.

#### application_gateway_ids_map `map(string)`

    Description: Specifies the map of Application Gateway Id's.

#### application_gateway_backend_pools_map `map(list(string))`

    Description: Specifies the map of Application Gateway Backend Address Pool Id's By Application Gateway Name.

#### application_gateway_backend_pool_ids_map `map(string)`

    Description: Specifies the map of Application Gateway Backend Address Pool Id By Backend Address Pool Name.

#### application_gateway_backend_pools `map(list(string))`

    Description: Specifies the map of Application Gateway Backend Address Pool Names's By Application Gateway Name.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_application_gateway](https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html) <br />
[azurerm_user_assigned_identity](https://www.terraform.io/docs/providers/azurerm/r/user_assigned_identity.html) <br />
[azurerm_web_application_firewall_policy](https://www.terraform.io/docs/providers/azurerm/r/web_application_firewall_policy.html)
