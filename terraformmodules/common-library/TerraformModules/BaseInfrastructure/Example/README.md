# Create Base Infrastructure Resources in Azure

This Module allows you to create and manage the standard resources required for all applications.

## Features

This module will:

- Create Resource Group in Microsoft Azure
- Create one or multiple Virtual Networks.
- Create one or multiple Subnets.
- Create one or multiple Network Security Groups for respective Subnet.
- Create one or multiple Route Tables for respective Subnet.
- Create one or multiple Storage Accounts used for diagnostics. This can either be used for specific application requirements or a separate Storage Account can be deployed.
- Create Base Key Vault used for storing of application secrets. If multiple Key Vaults are required, they can be deployed as part of the application kit. This can either be used for specific application requirements or a separate can Key Vault can be deployed.
- Create Base Log Analytics Workspace. The workspace Id is used for other modules to reference as a mandatory parameter for sending diagnostic information.

## Usage

```hcl
module "BaseInfrastructure" {
  source                           = "../../common-library/TerraformModules/BaseInfrastructure"
  resource_group_name              = var.resource_group_name              # Azure Resource Group Name
  location                         = var.location                         # Azure Region Name
  virtual_networks                 = var.virtual_networks                 # VNet's Block
  subnets                          = var.subnets                          # Subnet's Block
  route_tables                     = var.route_tables                     # Route Tables Block
  network_security_groups          = var.network_security_groups          # NSG Rules Block
  net_additional_tags              = var.additional_tags                  # Additional Tags
  vnet_peering                     = var.vnet_peering                     # VNet Peering Block
  base_infra_log_analytics_name    = var.base_infra_log_analytics_name    # Log Analytics Name
  sku                              = var.sku                              # Log Analytics SKU
  retention_in_days                = var.retention_in_days                # Log Analytics Retention In Days
  base_infra_storage_accounts      = var.base_infra_storage_accounts      # Storage Accounts Block
  containers                       = var.containers                       # SA Containers Block
  blobs                            = var.blobs                            # SA Blobs Block
  queues                           = var.queues                           # SA Queues Block
  file_shares                      = var.file_shares                      # SA File Shares Block
  tables                           = var.tables                           # SA Tables Block
  base_infra_keyvault_name         = var.base_infra_keyvault_name         # Key Valut Name
  sku_name                         = var.sku_name                         # Key Vault SKU Name
  network_acls                     = var.network_acls                     # Key Valut Network Access Block
  access_policies                  = var.access_policies                  # Key Vault Access Policies Block
  diagnostics_storage_account_name = var.diagnostics_storage_account_name # Key Valut  Storage Account for Diagnostics
  soft_delete_enabled              = var.soft_delete_enabled              # KV Soft Delete Flag
  purge_protection_enabled         = var.purge_protection_enabled         # KV Purge Protection Flag
  enabled_for_deployment           = var.enabled_for_deployment           # KV Enable for Deployment Flag
  enabled_for_disk_encryption      = var.enabled_for_disk_encryption      # KV Enable for Disk Encryption Flag
  enabled_for_template_deployment  = var.enabled_for_template_deployment  # KV Enable for Template Deployment Flag
  app_security_group_ids_map       = module.ApplicationSecurityGroup.app_security_group_ids_map
  firewall_private_ips_map         = module.Firewall.firewall_private_ips_map
  dependencies                     = [module.ApplicationSecurityGroup.depended_on_asg]
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

    Description: Specifies the name of the resource group in which to create the base infrastructure resources.

#### location `string`

    Description: Specifies the Azure Region where the Resource Group should exist.

#### net_location `string`

    Description: Specifies the Network resources location if different than the resource group's location.

#### virtual_networks `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Virtual Networks.

| Attribute            |  Data Type   | Field Type | Description                                                                                                                                        | Allowed Values |
| :------------------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                 |    string    |  Required  | The name of the virtual network. Changing this forces a new resource to be created.                                                                |                |
| address_space        | list(string) |  Required  | The address space that is used the virtual network. You can supply more than one address space. Changing this forces a new resource to be created. |                |
| dns_servers          | list(string) |  Optional  | List of IP addresses of DNS servers                                                                                                                |                |
| ddos_protection_plan |  object({})  |  Optional  | Specifies the Network DDOS Protection Block as mentioned below.                                                                                    |                |

#### ddos_protection_plan

| Attribute | Data Type | Field Type | Description                                             | Allowed Values |
| :-------- | :-------: | :--------: | :------------------------------------------------------ | :------------- |
| id        |  string   |  Required  | The Resource ID of DDoS Protection Plan.                |                |
| enable    |   bool    |  Optional  | Enable/disable DDoS Protection Plan on Virtual Network. | true, false    |

#### vnet_peering `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Virtual Network Peering which allows resources to access other resources in the linked virtual network.

| Attribute                    | Data Type | Field Type | Description                                                                                                                                                                                                                                                                                                                                                                    | Allowed Values |
| :--------------------------- | :-------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| destination_vnet_name        |  string   |  Required  | Specfies the Azure resource name of the remote virtual network. Changing this forces a new resource to be created.                                                                                                                                                                                                                                                             |                |
| destination_vnet_rg          |  string   |  Required  | The resource group name of the the remote virtual network.                                                                                                                                                                                                                                                                                                                     |                |
| vnet_key                     |  string   |  Required  | The key from the map of virtual networks specified in **_virtual_networks_** block. Specifies the name of source virtual network. Changing this forces a new resource to be created.                                                                                                                                                                                           |                |
| allow_virtual_network_access |   bool    |  Optional  | Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true.                                                                                                                                                                                                                                                               | true, false    |
| allow_forwarded_traffic      |   bool    |  Optional  | Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false.                                                                                                                                                                                                                                                                            | true, false    |
| allow_gateway_transit        |   bool    |  Optional  | Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.                                                                                                                                                                                                                                                                           | true, false    |
| use_remote_gateways          |   bool    |  Optional  | Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false. | true, false    |

#### subnets `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Subnets.

| Attribute         |    Data Type     | Field Type | Description                                                                                                                                                                                                     | Allowed Values                                                                                                                                                                                       |
| :---------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name              |      string      |  Required  | The name of the subnet. Changing this forces a new resource to be created.                                                                                                                                      |                                                                                                                                                                                                      |
| vnet_key          |      string      |  Required  | The key from the map of virtual networks specified in **_virtual_networks_** block. Specifies the name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created. |                                                                                                                                                                                                      |
| address_prefixes  |   list(string)   |  Required  | The address prefixes to use for the subnet.                                                                                                                                                                     |                                                                                                                                                                                                      |
| pe_enable         |       bool       |  Optional  | Enable or Disable network policies for the private link endpoint and private link service on the subnet. Default value is false.                                                                                | true, false                                                                                                                                                                                          |
| service_endpoints |   list(string)   |  Optional  | The list of Service endpoints to associate with the subnet.                                                                                                                                                     | Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage , Microsoft.Web |
| delegation        | list(object({})) |  Optional  | Specfies One or more delegation blocks as defined below.                                                                                                                                                        |                                                                                                                                                                                                      |

#### delegation

| Attribute          |    Data Type     | Field Type | Description                                              | Allowed Values |
| :----------------- | :--------------: | :--------: | :------------------------------------------------------- | :------------- |
| name               |      string      |  Required  | A name for this delegation.                              |                |
| service_delegation | list(object({})) |  Required  | Specifies the service_delegation block as defined below. |                |

#### service_delegation

| Attribute |  Data Type   | Field Type | Description                                                                                                   | Allowed Values                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| :-------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name      |    string    |  Required  | The name of service to delegate to.                                                                           | Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.DBforPostgreSQL/serversv2, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Web/hostingEnvironments , Microsoft.Web/serverFarms |
| actions   | list(string) |  Optional  | Specifies the list of Actions which should be delegated. This list is specific to the service to delegate to. | Microsoft.Network/networkinterfaces/\*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action , Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action                                                                                                                                                                                                                                               |

#### network_security_groups `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Network Securiy Groups.

| Attribute      |    Data Type     | Field Type | Description                                                                                          | Allowed Values |
| :------------- | :--------------: | :--------: | :--------------------------------------------------------------------------------------------------- | :------------- |
| name           |      string      |  Required  | Specifies the name of the network security group. Changing this forces a new resource to be created. |                |
| security_rules | list(object({})) |  Optional  | List of objects representing security rules mentioned in security_rules block as defined below.      |                |
| tags           |   map(string)    |  Optional  | Specifies the custom tags assigned to this NSG resource.                                             |                |

#### security_rules

| Attribute                                    |  Data Type   | Field Type | Description                                                                                                                                                                                                      | Allowed Values                         |
| :------------------------------------------- | :----------: | :--------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------- |
| name                                         |    string    |  Required  | The name of the security rule.                                                                                                                                                                                   |                                        |
| description                                  |    string    |  Optional  | A description for this rule. Restricted to 140 characters.                                                                                                                                                       |                                        |
| direction                                    |    string    |  Required  | The direction specifies if rule will be evaluated on incoming or outgoing traffic.                                                                                                                               | Inbound , Outbound                     |
| access                                       |    string    |  Required  | Specifies whether network traffic is allowed or denied.                                                                                                                                                          | Allow , Deny                           |
| priority                                     |    number    |  Required  | Specifies the priority of the rule. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.                                      | between 100 and 4096                   |
| source_address_prefix                        |    string    |  Optional  | CIDR or source IP range or \* to match any IP. Tags such as ‘VirtualNetwork’, ‘AzureLoadBalancer’ and ‘Internet’ can also be used. This is required if **_source_address_prefixes_** is not specified.           |                                        |
| source_address_prefixes                      | list(string) |  Optional  | List of source address prefixes. Tags may not be used. This is required if **_source_address_prefix_** is not specified.                                                                                         |                                        |
| destination_address_prefix                   |    string    |  Optional  | CIDR or destination IP range or \* to match any IP. Tags such as ‘VirtualNetwork’, ‘AzureLoadBalancer’ and ‘Internet’ can also be used. This is required if **_destination_address_prefixes_** is not specified. |                                        |
| destination_address_prefixes                 | list(string) |  Optional  | List of destination address prefixes. Tags may not be used. This is required if **_destination_address_prefix_** is not specified.                                                                               |                                        |
| destination_port_range                       |    string    |  Optional  | Destination Port or Range. Integer or range between 0 and 65535 or \* to match any. This is required if **_destination_port_ranges_** is not specified.                                                          | between 0 and 65535 or \* to match any |
| destination_port_ranges                      | list(string) |  Optional  | List of destination ports or port ranges. This is required if **_destination_port_range_** is not specified.                                                                                                     |                                        |
| protocol                                     |    string    |  Required  | Network protocol this rule applies to.                                                                                                                                                                           | Tcp, Udp, Icmp, or \* to match all     |
| source_port_range                            |    string    |  Optional  | Source Port or Range. Integer or range between 0 and 65535 or \* to match any. This is required if **_source_port_ranges_** is not specified.                                                                    | between 0 and 65535 or \* to match any |
| source_port_ranges                           | list(string) |  Optional  | List of source ports or port ranges. This is required if **_source_port_range_** is not specified.                                                                                                               |                                        |
| source_application_security_group_names      | list(string) |  Optional  | A List of source Application Security Group Names.                                                                                                                                                               |                                        |
| destination_application_security_group_names | list(string) |  Optional  | A List of destination Application Security Group Names.                                                                                                                                                          |                                        |

#### route_tables `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Route Tables.

| Attribute                     |    Data Type     | Field Type | Description                                                                                               | Allowed Values |
| :---------------------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------- | :------------- |
| name                          |      string      |  Required  | The name of the route table. Changing this forces a new resource to be created.                           |                |
| disable_bgp_route_propagation |       bool       |  Optional  | Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable. | true, false    |
| routes                        | list(object({})) |  Optional  | List of objects representing routes mentioned in routes block as below.                                   |                |

#### routes

| Attribute              | Data Type | Field Type | Description                                                                                                                                     | Allowed Values                                                      |
| :--------------------- | :-------: | :--------: | :---------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------ |
| name                   |  string   |  Required  | The name of the route.                                                                                                                          |                                                                     |
| address_prefix         |  string   |  Required  | The destination CIDR to which the route applies, such as 10.1.0.0/16                                                                            |                                                                     |
| next_hop_type          |  string   |  Required  | The type of Azure hop the packet should be sent to.                                                                                             | VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance , None |
| next_hop_in_ip_address |  string   |  Optional  | Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. |                                                                     |
| azure_firewall_name    |  string   |  Optional  | Specifies the firewall name where packets should be forwarded to.                                                                               |                                                                     |

#### mandatory_tags `object({})`

Description: Mandatory tags which are to be added to the resources
| Attribute | Data Type | Field Type | Description | Allowed Values |
| :------------- | :-------------: | :-------------: | :------------- | :------------- |
| created_by | string | Required | This is the person who creates the resource. AT&T UID may be specified as an email address – example: attuid@att.com, attuid@us.att.com. | |
| contact_dl | string | Required | This is the contact distribution list for the application the resource or resource group belongs to for operational support| |
| mots_id | string | Required |mots_id of the application.The application must have a MOTS ID before getting into the Public Cloud. | |
| auto_fix | string | Required | This tag is to flag ASTRA if it can apply AutoFix policies to security issues detected for resources deployed in the public cloud environment. If the value is set to “yes”, it enables ASTRA auto fix for the issues. If the value is set to “no”, ASTRA will notify the application owner of security violations and application owner must fix it manually | |

#### dependencies `list(any)`

    Description: Specifies the modules that the Base Infrastructure Resource depends on.

    Default: []

### **Optional Parameters**

#### net_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional resources tags, in addition to the resource group tags.

    Default: {}

#### app_security_group_ids_map `map(string)`

    Description: Specifies the Map of network interfaces Application Security Group Id's.

    Default: {}

#### firewall_private_ips_map `map(string)`

    Description: Specifies the Map of Azure Firewall Private Ip's.

    Default: {}

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_resource_group](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html) <br />
[azurerm_virtual_network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html) <br />
[azurerm_virtual_network_peering](https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html) <br />
[azurerm_subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html) <br />
[azurerm_network_security_group](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html) <br />
[azurerm_route_table](https://www.terraform.io/docs/providers/azurerm/r/route_table.html) <br />
