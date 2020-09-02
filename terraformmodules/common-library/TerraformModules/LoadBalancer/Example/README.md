# Create Load balancers in Azure

This module allows you to create one or multiple load balancers in Azure.

## Features

1. Create multiple private and public load balancers in an existing resource group.
2. Add multiple frontend ip's to load balancer.
3. Create inbound NAT rules and outbound rules on load balancer.
4. Create NAT pools for VMSS workloads.

## usage

```hcl
module "LoadBalancer" {
  source                  = "../../common-library/TerraformModules/LoadBalancer"
  load_balancers          = var.load_balancers
  resource_group_name     = module.BaseInfrastructure.resource_group_name
  subnet_ids              = module.BaseInfrastructure.map_subnet_ids
  load_balancer_rules     = var.load_balancer_rules
  load_balancer_nat_rules = var.load_balancer_nat_rules
  lb_outbound_rules       = var.lb_outbound_rules
  load_balancer_nat_pools = var.load_balancer_nat_pools
  lb_additional_tags      = var.additional_tags
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the load balancer module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the Load balancer module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the Load balancer module.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per AT&T standard naming conventions.
2.  While declaring variables with data type 'map(object)'. It's mandatory to define all the objects.If you don't want to use any specific objects define it as null or empty list as per the object data type.

    - for example:

    ```hcl
     variable "example" {
       type = map(object({
       name         = string
       permissions  = list(string)
       cmk_enable   = bool
       auto_scaling = string
     }))
    ```

    - In above example, if you don't want to use the objects permissions and auto_scaling, you can define it as below.

    ```hcl
     example = {
       name = "example"
       permissions = []
       auto_scaling = null
     }
    ```

3.  Please make sure all the Required parameters are declared.Refer below section to understand the required and optional parameters of this module.

4.  Please verify that the values provided to the variables are with in the allowed values.Refer below section to understand the allowed values to each parameter.

## Inputs

### **Required Parameters**

#### resource_group_name `string`

    The name of the resource group in which the Load balancer will be created.

#### load_balancers `map(object({}))`

    Map of load balancers which are to be created in a particular resource group.

| Attribute          |  Data Type   | Field Type | Description                                                                                                                                       | Allowed Values  |
| :----------------- | :----------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------ | :-------------- |
| name               |    string    |  Required  | Name of the Azure load balancer                                                                                                                   |                 |
| sku                |    string    |  Optional  | The SKU of the Azure Load Balancer. Defaults to Standard.                                                                                         | Basic, Standard |
| frontend_ips       | list(object) |  Required  | Specifies the list of **_frontend_ip_** blocks for Load balancer                                                                                  |                 |
| backend_pool_names | list(object) |  Required  | List of backend pool names                                                                                                                        |                 |
| enable_public_ip   |     bool     |  Optional  | want to create public load balancer ? set this argument to true                                                                                   | true, false     |
| public_ip_name     |    string    |  Optional  | Specifies the custom name for the public ip which is created for public load balancer. This is required if **_enable_public_ip_** is set to true. |                 |

#### frontend_ip

| Attribute   |  Data Type   | Field Type | Description                                                                            | Allowed Values |
| :---------- | :----------: | :--------: | :------------------------------------------------------------------------------------- | :------------- |
| name        |    string    |  Required  | frontend ip name of LB                                                                 |                |
| subnet_name |    string    |  Optional  | subnet name of LB in which LB is created                                               |                |
| static_ip   |    string    |  Optional  | Static private IP for load balancer                                                    |                |
| zones       | list(string) |  Optional  | A list of Availability Zones which the Load Balancer's IP Addresses should be created. |                |

#### subnet_ids `map(string)`

    subnet ID in which load balancer needs to be created

### **Optional Parameters**

#### load_balancer_rules `map(object({}))`

    Map of load balancer rules which needs to be created in a load balancer

| Attribute                 | Data Type | Field Type | Description                                                                                                                                                                                                                | Allowed Values                      |
| :------------------------ | :-------: | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------- |
| name                      |  string   |  Required  | Name of the load balancer rule                                                                                                                                                                                             |                                     |
| key                       |  string   |  Required  | key of the azure load balancer                                                                                                                                                                                             |                                     |
| frontend_ip_name          |  string   |  Required  | frontend ip name of the load balancer                                                                                                                                                                                      |                                     |
| backend_pool_name         |  string   |  Required  | bakcnedpool name of the load balancer                                                                                                                                                                                      |                                     |
| lb_protocol               |  string   |  Optional  | The transport protocol for the external endpoint.                                                                                                                                                                          | Tcp, Udp or All                     |
| lb_port                   |  number   |  Required  | The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Set this frontend port to 0 if **_lb_protocol_** is set to "All".                                                  | 0 to 65534                          |
| backend_port              |  number   |  Required  | The port used for internal connections on the endpoint. Set this backend port to 0 if **_lb_protocol_** is set to "All".                                                                                                   | 0 to 65535                          |
| enable_floating_ip        |   bool    |  Optional  | Are the Floating IPs enabled for this Load Balncer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false. | true, false                         |
| disable_outbound_snat     |   bool    |  Optional  | Is snat enabled for this Load Balancer Rule? Default false.                                                                                                                                                                | true,false                          |
| enable_tcp_reset          |   bool    |  Optional  | Is TCP Reset enabled for this Load Balancer Rule? Defaults to false.                                                                                                                                                       | true, false                         |
| probe_port                |  number   |  Required  | Port on which the Probe queries the backend endpoint.                                                                                                                                                                      | 0 to 65535                          |
| probe_protocol            |  string   |  Required  | Specifies the protocol of the end point backend endpoint.                                                                                                                                                                  | Http, Https or Tcp.                 |
| request_path              |  string   |  Optional  | The URI used for requesting health status from the backend endpoint. Required if **_probe_protocol_** is set to "Http"                                                                                                     |                                     |
| probe_interval            |  number   |  Optional  | The interval, in seconds between probes to the backend endpoint for health status.                                                                                                                                         |                                     |
| probe_unhealthy_threshold |  number   |  Optional  | The number of failed probe attempts after which the backend endpoint is removed from rotation.                                                                                                                             |                                     |
| load_distribution         |  string   |  Optional  | Specifies the load balancing distribution type to be used by the Load Balancer.                                                                                                                                            | Default,SourceIP,SourceIPProtocol,  |
| idle_timeout_in_minutes   |  number   |  Optional  | Specifies the idle timeout in minutes for TCP connections                                                                                                                                                                  | values are between 4 and 30 minutes |

#### load_balancer_nat_rules `map(object({}))`

    Map of Load balancer NAT rules which needs to be created in a Load balancer

| Attribute               | Data Type | Field Type | Description                                                | Allowed Values                      |
| :---------------------- | :-------: | :--------: | :--------------------------------------------------------- | :---------------------------------- |
| name                    |  string   |  Required  | name of the load balancer NAT rule                         |                                     |
| lb_key                  |  string   |  Required  | key name of load balancer                                  |                                     |
| frontend_ip_name        |  string   |  Required  | frontend ip name of load balancer                          |                                     |
| lb_port                 |  number   |  Required  | port used for External connections on the endpoint.        | values range between 1 and 65534    |
| backend_port            |  number   |  Required  | port used for internal connections on the endpoint.        | values range between 1 and 65535    |
| idle_timeout_in_minutes |  number   |  Required  | Specifies the idle timeout in minutes for TCP connections. | values are between 4 and 30 minutes |

#### load_balancer_nat_pools `map(object({}))`

    Map containing load balancer nat pool parameters for VMSS

| Attribute        | Data Type | Field Type | Description                                                                                                                               | Allowed Values                   |
| :--------------- | :-------: | :--------: | :---------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------- |
| name             |  string   |  Required  | Specifies the name of the NAT pool                                                                                                        |                                  |
| lb_key           |  string   |  Required  | key name of Load alancer                                                                                                                  |                                  |
| frontend_ip_name |  string   |  Required  | front end ip name of load balancer                                                                                                        |                                  |
| lb_port_start    |  number   |  Required  | The first port number in the range of external ports that will be used to provide Inbound Nat to NICs associated with this Load Balancer. | values range between 1 and 65534 |
| lb_port_end      |  number   |  Required  | The last port number in the range of external ports that will be used to provide Inbound Nat to NICs associated with this Load Balancer.  | values range between 1 and 65535 |
| backend_port     |  number   |  Required  | The port used for the internal endpoint.                                                                                                  | values range between 1 and 65535 |

#### lb_outbound_rules `map(object({}))`

    Map of load balancer rules which needs to be created in a load balancer

| Attribute                       |  Data Type   | Field Type | Description                                      | Allowed Values |
| :------------------------------ | :----------: | :--------: | :----------------------------------------------- | :------------- |
| name                            |    string    |  Required  | Name of the outbound rule                        |                |
| lb_key                          |    string    |  Required  | key name of the load balancer                    |                |
| protocol                        |    string    |  Required  | protocol for the external endpoint.              | Udp, Tcp, All  |
| allocated_outbound_ports        |    number    |  Required  | The number of outbound ports to be used for NAT. |                |
| frontend_ip_configuration_names | list(string) |  Required  | List of frontend ip config names                 |                |

#### lb_additional_tags `map(string)`

     A map of tags to load balancer resource.

## Outputs

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_lb](https://www.terraform.io/docs/providers/azurerm/r/lb.html) <br />
