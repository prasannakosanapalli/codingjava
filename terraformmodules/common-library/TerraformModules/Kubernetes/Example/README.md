# Create Azure Kubernetes Clusters in Azure

This Module allows you to create and manage Azure Kubernetes Clusters in Microsoft Azure.

## Features

This module will:

- Create one or multiple Azure Kubernetes Clusters in Microsoft Azure.
- Create one or multiple AKS Node Pools in the existing AKS Cluster.

## Usage

```hcl
module "Kubernetes" {
  providers = {
    azurerm     = azurerm
    azurerm.ado = azurerm # Set this to azurerm.ado instead of azurerm if both ADO Agents and Application are in different subscription
  }
  source                     = "../../common-library/TerraformModules/Kubernetes"
  resource_group_name        = module.BaseInfrastructure.resource_group_name
  subnet_ids                 = module.BaseInfrastructure.map_subnet_ids
  log_analytics_workspace_id = module.BaseInfrastructure.law_id
  key_vault_id               = module.BaseInfrastructure.key_vault_id
  aks_clusters               = var.aks_clusters
  aks_extra_node_pools       = var.aks_extra_node_pools
  ad_enabled                 = var.ad_enabled
  aks_client_id              = var.client_id
  aks_client_secret          = var.client_secret
  mgmt_key_vault_name        = var.mgmt_key_vault_name
  mgmt_key_vault_rg          = var.mgmt_key_vault_rg
  aks_client_app_id          = var.aks_client_app_id
  aks_server_app_id          = var.aks_server_app_id
  aks_server_app_secret      = var.aks_server_app_secret
  aks_additional_tags        = var.additional_tags
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

    Description: Specifies the name of the resource group in which to create the Azure Kubernetes Cluster.

#### subnet_ids `Map(string)`

    Description: Specifies the Map of Subnet Id's.

#### key_vault_id `string`

    Description: The Id of the Key Vault to which all secrets should be stored.

#### log_analytics_workspace_id `string`

    Description: Specifies the Log Analytics Workspace resource workspace id.

#### dependencies `list(any)`

    Description: Specifies the modules that the Azure Kubernetes Cluster Resource depends on.

    Default: []

#### aks_clusters `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Azure Kubernetes Clusters.

| Attribute                       |  Data Type   | Field Type | Description                                                                                                                                                                                | Allowed Values                                                             |
| :------------------------------ | :----------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------- |
| name                            |    string    |  Required  | The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created.                                                                                   |                                                                            |
| sku_tier                        |    string    |  Optional  | The SKU Tier that should be used for this Kubernetes Cluster. Changing this forces a new resource to be created. Defaults to Free.                                                         | Free and Paid (which includes the Uptime SLA)                              |
| dns_prefix                      |    string    |  Required  | DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created.                                                                                 |                                                                            |
| kubernetes_version              |    string    |  Optional  | Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade).        | supported versions in eastus2 region for CMK : 1.18.2,1.18.1,1.17.5,1.17.4 |
| docker_bridge_cidr              |    string    |  Optional  | IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created.                                                            |                                                                            |
| service_address_range           |    string    |  Optional  | The Network Range used by the Kubernetes service. Changing this forces a new resource to be created.                                                                                       |                                                                            |
| dns_ip                          |    string    |  Optional  | IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created.                       |                                                                            |
| rbac_enabled                    |     bool     |  Optional  | Specifies whether to anble role based access control for the Azure Kubernetes Cluster.                                                                                                     | true, false                                                                |
| cmk_enabled                     |     bool     |  Optional  | Specifies whether to enable customer managed keys encryption for the Azure Kubernetes Cluster. Customer Managed keys are only supported in Kubernetes versions greater than 1.17           | true, false                                                                |
| assign_identity                 |     bool     |  Optional  | Specifies whether to enable Managed System Identity for the Azure Kubernetes Cluster.                                                                                                      | true, false                                                                |
| admin_username                  |    string    |  Required  | The Admin Username for the Cluster. Changing this forces a new resource to be created.                                                                                                     |                                                                            |
| api_server_authorized_ip_ranges | list(string) |  Optional  | The IP ranges to whitelist for incoming traffic to the masters.                                                                                                                            |                                                                            |
| network_plugin                  |    string    |  Optional  | Network plugin to use for networking. Defaults to azure. Changing this forces a new resource to be created.                                                                                | azure, kubenet                                                             |
| network_policy                  |    string    |  Optional  | Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Defaults to azure. Changing this forces a new resource to be created. | calico, azure                                                              |
| pod_cidr                        |    string    |  Optional  | The CIDR to use for pod IP addresses. This field can only be set when `network_plugin` is set to `kubenet`. Changing this forces a new resource to be created.                             |                                                                            |
| aks_default_pool                |  object({})  |  Required  | A `default_node_pool` block as defined below.                                                                                                                                              |                                                                            |
| auto_scaler_profile             |  object({})  |  Optional  | A `auto_scaler_profile` block as defined below.                                                                                                                                            |                                                                            |
| load_balancer_profile           |  object({})  |  Optional  | A `load_balancer_profile` block as defined below.                                                                                                                                          |                                                                            |

#### default_node_pool

| Attribute           |  Data Type   | Field Type | Description                                                                                                                      | Allowed Values                                        |
| :------------------ | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------- |
| name                |    string    |  Required  | The name which should be used for the default Kubernetes Node Pool. Changing this forces a new resource to be created.           |                                                       |
| vm_size             |    string    |  Required  | The size of the Virtual Machine, such as Standard_DS2_v2.                                                                        |                                                       |
| availability_zones  | list(string) |  Optional  | A list of Availability Zones across which the Node Pool should be spread.                                                        |                                                       |
| enable_auto_scaling |     bool     |  Optional  | Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to false.                                              | true, false                                           |
| max_pods            |    number    |  Optional  | The maximum number of pods that can run on each agent. Changing this forces a new resource to be created.                        |                                                       |
| os_disk_size_gb     |    number    |  Optional  | The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created. |                                                       |
| subnet_name         |    string    |  Optional  | The Name of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created.             |                                                       |
| node_count          |    number    |  Required  | The initial number of nodes which should exist in this Node Pool.                                                                | between 1 and 100 and between min_count and max_count |
| max_count           |    number    |  Required  | The maximum number of nodes which should exist in this Node Pool.                                                                | between 1 and 100                                     |
| min_count           |    number    |  Required  | The minimum number of nodes which should exist in this Node Pool.                                                                | between 1 and 100                                     |

#### auto_scaler_profile

| Attribute                        | Data Type | Field Type | Description                                                                                                                                              | Allowed Values |
| :------------------------------- | :-------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| balance_similar_node_groups      |   bool    |  Optional  | Detect similar node groups and balance the number of nodes between them. Defaults to false.                                                              | true, false    |
| max_graceful_termination_sec     |  number   |  Optional  | Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node. Defaults to 600.                            |                |
| scale_down_delay_after_add       |  string   |  Optional  | How long after the scale up of AKS nodes the scale down evaluation resumes. Defaults to 10m.                                                             |                |
| scale_down_delay_after_delete    |  string   |  Optional  | How long after node deletion that scale down evaluation resumes. Defaults to the value used for `scan_interval`.                                         |                |
| scale_down_delay_after_failure   |  string   |  Optional  | How long after scale down failure that scale down evaluation resumes. Defaults to 3m.                                                                    |                |
| scan_interval                    |  string   |  Optional  | How often the AKS Cluster should be re-evaluated for scale up/down. Defaults to 10s.                                                                     |                |
| scale_down_unneeded              |  string   |  Optional  | How long a node should be unneeded before it is eligible for scale down. Defaults to 10m.                                                                |                |
| scale_down_unready               |  string   |  Optional  | How long an unready node should be unneeded before it is eligible for scale down. Defaults to 20m.                                                       |                |
| scale_down_utilization_threshold |  number   |  Optional  | Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down. Defaults to 0.5. |                |

#### load_balancer_profile

| Attribute                 |  Data Type   | Field Type | Description                                                                                                      | Allowed Values                |
| :------------------------ | :----------: | :--------: | :--------------------------------------------------------------------------------------------------------------- | :---------------------------- |
| outbound_ports_allocated  |    number    |  Optional  | Number of desired SNAT port for each VM in the clusters load balancer. Defaults to 0.                            | between 0 and 64000 inclusive |
| idle_timeout_in_minutes   |    number    |  Optional  | Desired outbound flow idle timeout in minutes for the cluster load balancer. Defaults to 30.                     | between 4 and 120 inclusive   |  |
| managed_outbound_ip_count |    number    |  Optional  | Count of desired managed outbound IPs for the cluster load balancer.                                             | between 1 and 100 inclusive   |
| outbound_ip_address_ids   | list(string) |  Optional  | The ID of the Public IP Addresses which should be used for outbound communication for the cluster load balancer. |                               |

#### aks_client_id `string`

    Description: Specifies the client id (app id) of service principal used for authentication to Azure. This argument is required if `assign_identity` is specified.

#### aks_client_secret `string`

    Description: Specifies the secret associated with the service principal. This argument is required if `assign_identity` is specified.

### **Optional Parameters**

#### aks_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional Azure Kubernetes Cluster resources tags, in addition to the resource group tags.

    Default: {}

#### ad_enabled `bool`

    Description: Is AAD integration enabled for the following cluster? Defaults to false.

#### aks_client_app_id `string`

    Description: The Key Vault Secret Name contains the ID of an Azure Active Directory client application of type "Native". This application is for user login via kubectl.

#### aks_server_app_id `string`

    Description: The Key Vault Secret Name contains the ID of an Azure Active Directory server application of type "Web app/API". This application represents the managed cluster's apiserver (Server application).

#### aks_server_app_secret `string`

    Description: The Key Vault Secret Name of an Azure Active Directory server application.

#### mgmt_key_vault_rg `string`

    Description: Specifies the Resource Group name of the Key Vault where AAD Secrets are stored.

#### mgmt_key_vault_name `string`

    Description: Specifies the name of the Key Vault where AAD Secrets are stored.

#### aks_extra_node_pools `map(object({}))`

    Description: Specifies the Map of objects containing attributes for Node Pools within a Kubernetes Cluster.

| Attribute           |  Data Type   | Field Type | Description                                                                                                                         | Allowed Values                                                           |
| :------------------ | :----------: | :--------: | :---------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------- |
| name                |    string    |  Required  | The name of the Node Pool which should be created within the Kubernetes Cluster. Changing this forces a new resource to be created. |                                                                          |
| aks_key             |    string    |  Required  | Specifies the key from the map of `aks_clusters` where the node pool is to be created.                                              |                                                                          |
| vm_size             |    string    |  Required  | The SKU which should be used for the Virtual Machines used in this Node Pool. Changing this forces a new resource to be created.    |                                                                          |
| availability_zones  | list(string) |  Optional  | A list of Availability Zones where the Nodes in this Node Pool should be created in.                                                |                                                                          |
| enable_auto_scaling |     bool     |  Optional  | Whether to enable auto-scaler. Defaults to false.                                                                                   | true, false                                                              |
| max_pods            |    number    |  Optional  | The maximum number of pods that can run on each agent. Changing this forces a new resource to be created.                           |                                                                          |
| mode                |    string    |  Optional  | Should this Node Pool be used for System or User resources? Defaults to User.                                                       | System and User                                                          |
| os_disk_size_gb     |    number    |  Optional  | The Agent Operating System disk size in GB. Changing this forces a new resource to be created.                                      |                                                                          |
| subnet_name         |    string    |  Optional  | The Name of a Subnet where the Kubernetes Node Pool should exist.                                                                   |                                                                          |
| node_count          |    number    |  Required  | The initial number of nodes which should exist within this Node Pool                                                                | between 1 and 100 and must be a value in the range min_count - max_count |
| max_count           |    number    |  Required  | The maximum number of nodes which should exist within this Node Pool.                                                               | between 1 and 100 and must be greater than or equal to min_count         |
| min_count           |    number    |  Required  | The minimum number of nodes which should exist within this Node Pool.                                                               | between 1 and 100 and must be less than or equal to max_count            |

## Outputs

#### aks_resource_ids `list(string)`

    Description: Specifies the list of Azure Kubernetes Cluster resource id's.

#### aks_resource_ids_map `map(string)`

    Description: Specifies the map of Azure Kubernetes Cluster resource id's.

#### aks

    Description: Specifies the map of Azure Kubernetes Cluster resources.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_kubernetes_cluster](https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html) <br />
[azurerm_kubernetes_cluster_node_pool](https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster_node_pool.html)
