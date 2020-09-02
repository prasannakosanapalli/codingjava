# Create App Services in Azure

This Module allows you to create and manage one or multiple App Services in Microsoft Azure.

## Features

This module will:

- Create one or multiple App Service Plans in Microsoft Azure.
- Create one or multiple App Services in the specified App Service Plan.

## Usage

```hcl
module "AppService" {
  source                      = "../../common-library/TerraformModules/AppService"
  resource_group_name         = module.BaseInfrastructure.resource_group_name
  app_service_plans           = var.app_service_plans
  app_services                = var.app_services
  app_service_additional_tags = var.additional_tags
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

    Description: Specifies the name of the resource group in which to create the App Services.

#### app_service_plans `map(object({}))`

    Description: Specifies the Map of objects containing attributes for App Service Plans to be created.

    Default: {}

| Attribute                    | Data Type | Field Type | Description                                                                                                                                                                                            | Allowed Values |
| :--------------------------- | :-------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                         |  string   |  Required  | Specifies the name of the App Service Plan component. Changing this forces a new resource to be created.                                                                                               |                |
| kind                         |  string   |  Optional  | The kind of the App Service Plan to create. Possible values are Windows (also available as App), Linux, elastic (for Premium Consumption) and FunctionApp (for a Consumption Plan). Defaults to Linux. |                |
| reserved                     |   bool    |  Optional  | Is this App Service Plan Reserved. Defaults to false.                                                                                                                                                  | true, false    |
| per_site_scaling             |   bool    |  Optional  | Can Apps assigned to this App Service Plan be scaled independently? If set to false apps assigned to this plan will scale to all instances of the plan. Defaults to false.                             | true, false    |
| maximum_elastic_worker_count |  number   |  Optional  | The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan.                                                                                                             |                |
| sku_tier                     |  string   |  Required  | Specifies the plan's pricing tier.                                                                                                                                                                     |                |
| sku_size                     |  string   |  Required  | Specifies the plan's instance size.                                                                                                                                                                    |                |
| sku_capacity                 |  number   |  Optional  | Specifies the number of workers associated with this App Service Plan.                                                                                                                                 |                |

#### app_services `map(object({}))`

    Description: Specifies the Map of objects containing attributes for App Services.

    Default: {}

| Attribute               |    Data Type     | Field Type | Description                                                                                                                 | Allowed Values |
| :---------------------- | :--------------: | :--------: | :-------------------------------------------------------------------------------------------------------------------------- | :------------- |
| name                    |      string      |  Required  | Specifies the name of the App Service. Changing this forces a new resource to be created.                                   |                |
| app_service_plan_key    |      string      |  Required  | Specifies the key of the Map of App Service Plans within which to create this App Service.                                  |                |
| app_settings            |   map(string)    |  Optional  | A key-value pair of App Settings.                                                                                           |                |
| client_affinity_enabled |       bool       |  Optional  | Should the App Service send session affinity cookies, which route client requests in the same session to the same instance? | true, false    |
| client_cert_enabled     |       bool       |  Optional  | Does the App Service require client certificates for incoming requests? Defaults to false.                                  | true, false    |
| enabled                 |       bool       |  Optional  | Is the App Service Enabled?                                                                                                 | true, false    |
| https_only              |       bool       |  Optional  | Can the App Service only be accessed via HTTPS? Defaults to true.                                                           | true, false    |
| assign_identity         |       bool       |  Optional  | The System Managed Service Identity is to be created or not ?                                                               | true, false    |
| auth_settings           |    object({})    |  Optional  | A `auth_settings` block as defined below.                                                                                   |                |
| storage_accounts        | list(object({})) |  Optional  | One or more `storage_account` blocks as defined below.                                                                      |                |
| backup                  |    object({})    |  Optional  | A `backup` block as defined below.                                                                                          |                |
| connection_strings      | list(object({})) |  Optional  | One or more `connection_string` blocks as defined below.                                                                    |                |
| site_config             |    object({})    |  Optional  | A `site_config` block as defined below.                                                                                     |                |
| logs                    |    object({})    |  Optional  | A `logs` block as defined below.                                                                                            |                |

#### auth_settings

| Attribute                      |  Data Type   | Field Type | Description                                                                                                                                | Allowed Values                                                       |
| :----------------------------- | :----------: | :--------: | :----------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------- |
| enabled                        |     bool     |  Required  | Is Authentication enabled?                                                                                                                 | true, false                                                          |
| additional_login_params        | map(string)  |  Optional  | Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value". |                                                                      |
| allowed_external_redirect_urls | list(string) |  Optional  | External URLs that can be redirected to as part of logging in or logging out of the app.                                                   |                                                                      |
| default_provider               |    string    |  Optional  | The default provider to use when multiple providers have been set up.                                                                      | AzureActiveDirectory, Facebook, Google, MicrosoftAccount and Twitter |
| issuer                         |    string    |  Optional  | Issuer URI. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/. |                                                                      |
| runtime_version                |    string    |  Optional  | The runtime version of the Authentication/Authorization module.                                                                            |                                                                      |
| token_refresh_extension_hours  |    number    |  Optional  | The number of hours after session token expiration that a session token can be used to call the token refresh API. Defaults to 72.         |                                                                      |
| token_store_enabled            |     bool     |  Optional  | If enabled the module will durably store platform-specific security tokens that are obtained during login flows. Defaults to false.        | true, false                                                          |
| unauthenticated_client_action  |    string    |  Optional  | The action to take when an unauthenticated client attempts to access the app.                                                              | AllowAnonymous or RedirectToLoginPage                                |

#### storage_account

| Attribute    | Data Type | Field Type | Description                                                          | Allowed Values          |
| :----------- | :-------: | :--------: | :------------------------------------------------------------------- | :---------------------- |
| name         |  string   |  Required  | The name of the storage account identifier.                          |                         |
| type         |  string   |  Required  | The type of storage.                                                 | AzureBlob or AzureFiles |
| account_name |  string   |  Required  | The name of the storage account.                                     |                         |
| share_name   |  string   |  Required  | The name of the file share (container name, for Blob storage).       |                         |
| access_key   |  string   |  Required  | The access key for the storage account.                              |                         |
| mount_path   |  string   |  Optional  | The path to mount the storage within the site's runtime environment. |                         |

#### backup

| Attribute           | Data Type  | Field Type | Description                                                       | Allowed Values |
| :------------------ | :--------: | :--------: | :---------------------------------------------------------------- | :------------- |
| name                |   string   |  Required  | Specifies the name for this Backup.                               |                |
| enabled             |    bool    |  Required  | Is this Backup enabled?                                           | true, false    |
| storage_account_url |   string   |  Optional  | The SAS URL to a Storage Container where Backups should be saved. |                |
| schedule            | object({}) |  Optional  | A `schedule` block as defined below.                              |                |

#### schedule

| Attribute                | Data Type | Field Type | Description                                                                                                            | Allowed Values |
| :----------------------- | :-------: | :--------: | :--------------------------------------------------------------------------------------------------------------------- | :------------- |
| frequency_interval       |  number   |  Required  | Sets how often the backup should be executed.                                                                          |                |
| frequency_unit           |  string   |  Optional  | Sets the unit of time for how often the backup should be executed.                                                     | Day or Hour    |
| keep_at_least_one_backup |   bool    |  Optional  | Should at least one backup always be kept in the Storage Account by the Retention Policy, regardless of how old it is? | true, false    |
| retention_period_in_days |  number   |  Optional  | Specifies the number of days after which Backups should be deleted.                                                    |                |
| start_time               |  string   |  Optional  | Sets when the schedule should start working.                                                                           |                |

#### connection_string

| Attribute | Data Type | Field Type | Description                          | Allowed Values                                                                                                      |
| :-------- | :-------: | :--------: | :----------------------------------- | :------------------------------------------------------------------------------------------------------------------ |
| name      |  string   |  Required  | The name of the Connection String.   |                                                                                                                     |
| type      |  string   |  Required  | The type of the Connection String.   | APIHub, Custom, DocDb, EventHub, MySQL, NotificationHub, PostgreSQL, RedisCache, ServiceBus, SQLAzure and SQLServer |
| value     |  string   |  Required  | The value for the Connection String. |                                                                                                                     |

#### site_config

| Attribute                        |    Data Type     | Field Type | Description                                                                                                               | Allowed Values                                                                                                                                                                                                             |
| :------------------------------- | :--------------: | :--------: | :------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| always_on                        |       bool       |  Optional  | Should the app be loaded at all times? Defaults to false.                                                                 | true, false                                                                                                                                                                                                                |
| app_command_line                 |      string      |  Optional  | App command line to launch, e.g. /sbin/myserver -b 0.0.0.0.                                                               |                                                                                                                                                                                                                            |
| default_documents                |   list(string)   |  Optional  | The ordering of default documents to load, if an address isn't specified.                                                 |                                                                                                                                                                                                                            |
| dotnet_framework_version         |      string      |  Optional  | The version of the .net framework's CLR used in this App Service.                                                         | v2.0 (which will use the latest version of the .net framework for the .net CLR v2 - currently .net 3.5) and v4.0 (which corresponds to the latest version of the .net CLR v4 - which at the time of writing is .net 4.7.1) |
| ftps_state                       |      string      |  Optional  | State of FTP / FTPS service for this App Service.                                                                         | AllAllowed, FtpsOnly and Disabled                                                                                                                                                                                          |
| http2_enabled                    |       bool       |  Optional  | Is HTTP2 Enabled on this App Service? Defaults to false.                                                                  | true, false                                                                                                                                                                                                                |
| java_version                     |      string      |  Optional  | The version of Java to use. If specified `java_container` and `java_container_version` must also be specified.            | 1.7, 1.8 and 11 and their specific versions - except for Java 11 (e.g. 1.7.0_80, 1.8.0_181, 11)                                                                                                                            |
| java_container                   |      string      |  Optional  | The Java Container to use. If specified `java_version` and `java_container_version` must also be specified.               | JAVA, JETTY, and TOMCAT                                                                                                                                                                                                    |
| java_container_version           |      string      |  Optional  | The version of the Java Container to use. If specified `java_version` and `java_container` must also be specified.        |                                                                                                                                                                                                                            |
| local_mysql_enabled              |       bool       |  Optional  | Is "MySQL In App" Enabled? This runs a local MySQL instance with your app and shares resources from the App Service plan. | true, false                                                                                                                                                                                                                |
| linux_fx_version                 |      string      |  Optional  | Linux App Framework and version for the App Service.                                                                      | Docker container `(DOCKER|<user/image:tag>)`, a base-64 encoded Docker Compose file `(COMPOSE|${filebase64("compose.yml")})` or a base-64 encoded Kubernetes Manifest `(KUBE|${filebase64("kubernetes.yml")})`             |
| linux_fx_version_local_file_path |      string      |  Optional  | Local file path to Docker Compose or Kubernetes Manifest File.                                                            |                                                                                                                                                                                                                            |
| windows_fx_version               |      string      |  Optional  | The Windows Docker container image.                                                                                       | `(DOCKER|<user/image:tag>)`                                                                                                                                                                                                |
| managed_pipeline_mode            |      string      |  Optional  | The Managed Pipeline Mode. Defaults to Integrated.                                                                        | Integrated and Classic                                                                                                                                                                                                     |
| min_tls_version                  |      string      |  Optional  | The minimum supported TLS version for the app service. Defaults to 1.2 for new app services.                              | 1.0, 1.1, and 1.2                                                                                                                                                                                                          |
| php_version                      |      string      |  Optional  | The version of PHP to use in this App Service.                                                                            | 5.5, 5.6, 7.0, 7.1, 7.2, and 7.3                                                                                                                                                                                           |
| python_version                   |      string      |  Optional  | The version of Python to use in this App Service.                                                                         | 2.7 and 3.4                                                                                                                                                                                                                |
| remote_debugging_enabled         |       bool       |  Optional  | Is Remote Debugging Enabled? Defaults to false.                                                                           | true, false                                                                                                                                                                                                                |
| remote_debugging_version         |      string      |  Optional  | Which version of Visual Studio should the Remote Debugger be compatible with?                                             | VS2012, VS2013, VS2015 and VS2017                                                                                                                                                                                          |
| scm_type                         |      string      |  Optional  | The type of Source Control enabled for this App Service. Defaults to None.                                                | BitbucketGit, BitbucketHg, CodePlexGit, CodePlexHg, Dropbox, ExternalGit, ExternalHg, GitHub, LocalGit, None, OneDrive, Tfs, VSO, and VSTSRM                                                                               |
| use_32_bit_worker_process        |       bool       |  Optional  | Should the App Service run in 32 bit mode, rather than 64 bit mode?                                                       | true, false                                                                                                                                                                                                                |
| websockets_enabled               |       bool       |  Optional  | Should WebSockets be enabled?                                                                                             | true, false                                                                                                                                                                                                                |
| cors                             |    object({})    |  Optional  | A `cors` block as defined below.                                                                                          |                                                                                                                                                                                                                            |
| ip_restriction                   | list(object({})) |  Optional  | A List of `ip_restriction` objects representing ip restrictions as defined below.                                         |                                                                                                                                                                                                                            |

#### cors

| Attribute           |  Data Type   | Field Type | Description                                                                                           | Allowed Values |
| :------------------ | :----------: | :--------: | :---------------------------------------------------------------------------------------------------- | :------------- |
| allowed_origins     | list(string) |  Optional  | A list of origins which should be able to make cross-origin calls. \* can be used to allow all calls. |                |
| support_credentials |     bool     |  Optional  | Are credentials supported?                                                                            | true, false    |

#### ip_restriction

| Attribute                 | Data Type | Field Type | Description                                                   | Allowed Values |
| :------------------------ | :-------: | :--------: | :------------------------------------------------------------ | :------------- |
| ip_address                |  string   |  Optional  | The IP Address used for this IP Restriction in CIDR notation. |                |
| virtual_network_subnet_id |  string   |  Optional  | The Virtual Network Subnet ID used for this IP Restriction.   |                |

#### logs

| Attribute        | Data Type  | Field Type | Description                                   | Allowed Values |
| :--------------- | :--------: | :--------: | :-------------------------------------------- | :------------- |
| application_logs | object({}) |  Optional  | An `application_logs` block as defined below. |                |
| http_logs        | object({}) |  Optional  | An `http_logs` block as defined below.        |                |

#### application_logs

| Attribute          | Data Type  | Field Type | Description                                     | Allowed Values |
| :----------------- | :--------: | :--------: | :---------------------------------------------- | :------------- |
| azure_blob_storage | object({}) |  Optional  | An `azure_blob_storage` block as defined below. |                |

#### http_logs

| Attribute          | Data Type  | Field Type | Description                                     | Allowed Values |
| :----------------- | :--------: | :--------: | :---------------------------------------------- | :------------- |
| file_system        | object({}) |  Optional  | A `file_system` block as defined below.         |                |
| azure_blob_storage | object({}) |  Optional  | An `azure_blob_storage` block as defined below. |                |

#### file_system

| Attribute         | Data Type | Field Type | Description                                                                     | Allowed Values |
| :---------------- | :-------: | :--------: | :------------------------------------------------------------------------------ | :------------- |
| retention_in_days |  number   |  Required  | The number of days to retain logs for.                                          |                |
| retention_in_mb   |  number   |  Required  | The maximum size in megabytes that http log files can use before being removed. |                |

#### azure_blob_storage

| Attribute         | Data Type | Field Type | Description                                                                         | Allowed Values                               |
| :---------------- | :-------: | :--------: | :---------------------------------------------------------------------------------- | :------------------------------------------- |
| level             |  string   |  Required  | The level at which to log. **_NOTE_**: this field is not available for `http_logs`. | Error, Warning, Information, Verbose and Off |
| sas_url           |  string   |  Required  | The URL to the storage container, with a Service SAS token appended.                |                                              |
| retention_in_days |  number   |  Required  | The number of days to retain logs for.                                              |                                              |

### **Optional Parameters**

#### app_service_additional_tags `map(string)`

    Description: A mapping of tags to assign to the resource. Specifies additional App Services resources tags, in addition to the resource group tags.

    Default: {}

#### existing_app_service_plans `map(object({}))`

    Description: Specifies the Map of objects containing attributes for existing App Service Plans.

    Default: {}

| Attribute           | Data Type | Field Type | Description                                                                    | Allowed Values |
| :------------------ | :-------: | :--------: | :----------------------------------------------------------------------------- | :------------- |
| name                |  string   |  Required  | Specifies the name of the existing App Service Plan component.                 |                |
| resource_group_name |  string   |  Required  | Specifies the name of the resource group in which the App Service Plan exists. |                |

## Outputs

#### app_services `map(string)`

    Description: Map output of the App Services

#### app_service_plans `map(string)`

    Description: Map output of the App Service Plans

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Reference

[azurerm_app_service_plan](https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html) <br />
[azurerm_app_service](https://www.terraform.io/docs/providers/azurerm/r/app_service.html)
