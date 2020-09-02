# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.7.0] - 2020-08-10

### Added

- Create a ACR module in common library [#133353](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/133353).
- Add availability set feature to VM module [#127061](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/127061)
- Added Multiple NIC feature to VM Module [#127070](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/127070)

### Changed

- Unable to access KeyVault while provisioning resources [#150200](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/150200)
- Unable to create Zone Redundant Standard Load Balancer [#148678](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/148678)
- Unable to add Rewrite Rule Sets using Application Gateway module on common library [#150658](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/150658/)
- Can not add multiple network in dns [#137298](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/137298)
- Unable to add multiple vnet in dns [#137299](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/137299)
- Storage account not able to store secret in keyvault after identity set to true [#137300](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/137300)
- Refactoring of MSFT common library to add multiple IPs to a single NIC [#125239](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library/pullrequest/1055)
- [Kubernetes module] Add network_policy to the network_profile [#133352](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/133352)

## [0.6.0] - 2020-07-14

### Added

- Create Datafactory Module [#111616](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/111616)

### Changed

- Unable to assign log_workspace tag to NSG [#118103](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/118103)

## [0.5.5] - 2020-07-10

### Added

- Verify the log analytics workspace_id and workspace_secret will be stored in Azure key vault. [#117960](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/117960)
- Upgrade to provider 2.14.0 [#111631](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/111631)
- Upgrade AKS to 2.14.0 Provider [#116403](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/116403)

### Changed

- Remove hard coded docker cidr [#111629](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/111629)
- Rename "k8s" to "aks" in module [#111628](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/111628)

## [0.5.4] - 2020-07-03

### Added

- Added NSG flow logs [#111617](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/111617)

### Changed

- Issue: Creation of PE in DevopsRG while ProdDeployment [#117589](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/117589)
- Issue: v0.5.0 TF backend for prod looks for devops RG in prod subscription [#117396](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/117396)

## [0.5.3] - 2020-06-29

### Added

- Create Example Folder and Readme File for App Service [#113591](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/113591)
- Create App Service module [#111615](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/111615)
- Association of VM NIC's to LB NAT rules [#111621](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/111621)
- Association of VMSS to LB NAT pool [#111624](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/111624)

### Changed

- Application gateway backend http settings is not allowing to reference ssl certificate from keyvault [#116271](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/116271)
- Remove reader role assignment to keyvault for disk encryption set MSI on VM Module [#111620](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/111620)
- Remove reader role assignment to keyvault for disk encryption set MSI on  VMSS Module [#111625](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/111625)

## [0.5.2] - 2020-06-23

### Added

- Map Application Gateway Backend Address Pool Ids to VMSS and VM [#113746](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/113746)

## [0.5.1] - 2020-06-19

### Added

- Create Example Folder and Readme File for App Service [#113591](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/113591)
- Create App Service module [#111615](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/111615)
- Added Custom auto_scale settings for VMSS [#111627](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/111627)

### Changed

- Issue: Common Library 5.0, public ip tags not being applied [#112841](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/112841)
- Issue: Common Library 5.0, key vault dependency issue [#111889](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/111889)

## [0.5.0] - 2020-06-16

### Added

- Add Custom Script Extension to VM and VMSS [#109059](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/109059)
- Added PostgreSqlDatabase Module [#91744](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/91744)
- Add custom WAF policies to app gateway module [#91779](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91779)
- Enabled Rbac And Azure Active Directory Integration [#87946](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/87946)
- Update design decisions for SA [#91835](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91835)
- Update examples folder and changelog for SA [#91836](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91836)
- Update kits to use revised SA module design [#91846](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91846)
- Create application security group module [#91746](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91746)
- Create NSG Rules based on ASG [#102453](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/102453)
- Associate ASG with VM NIC [#102452](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/102452)
- Create Application Gateway Module [#91748](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91748/)
- Add Path based routing feature to application gateway module [#91778](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91778/)
- Add redirection feature to application gateway module [#91780](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91780/)
- Create Example Directory and Readme file for Application Gateway Module [#94987](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/94987/)
- Update ImageBuilder to let storage account blob dictate image version [#75673](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/75673)
- Ability to create multiple VMs with each VM supporting its own image id [#91030](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91030)
- Added Mandatory tags to the resources[#91777](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/91777)

### Changed

- Update Load balancer module to include HA port rule [#106853](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/106853)
- Use custom name for public ip resource in public load balancer module [#108579](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/108579)
- Upgrade Common-Library Modules to 2.10.0 azurerm provider [#104719](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/104719)
- Remove PE Module out of SA [#91769](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91769)
- Removed image builder components from common library [#82521](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/82521)
- Create DNSARecords for Previously created Private Endpoints [#102427](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/102427)
- Updated VM and VMSS to fix Custom arguments bug [#101899](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/101899)

## [0.4.1] - 2020-05-29

### Added

- Custom arguments to cloud-init script on VM and VMSS [#87956](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/87956)
- Add VMInsights Extension to VM and VMSS [#91786](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91786)
- Add VMInsights Solution to Log Analytics Workspace [#91785](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91785)
- Added Azure Firewall Module [#87953](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/87953)

### Changed

- Refactor DNSARecord to accept custom names from user [#91829](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91829)
- Update DNSARecord Module to support multiple DNSARecord Creation [#91828](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91828)
- Enable/Disable Creation of DNS A Record from config [#91827](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91827)
- As a CD pipeline, I need to specify the name of the DNS A record entirely. [#81671](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81671)
- As a CD pipeline, I need to create multiple DNS A records per Private Endpoint [#81673](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81673)
- Refactor Azure Monitor to add Scheduled Query Rule Alerts [#91783](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91783)
- Update Azure Monitor Example Folder and Readme File [#91784](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91784)
- Create Feature of adding NIC to multiple backend pools of LB's [#91773](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/91773)

## [0.4.0] - 2020-05-19

### Added

- Create private DNS zones and link for ADO agents [#90128](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/90128)
- Storage Account Module - Document Security Decisions in Code [#71740](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71740)
- VM Module - Document Security Decisions in Code [#71739](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71739)
- Added Example directories for VM,VMSS,storage account,log Analytics, key vault, Load balancer modules [#75892](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/75892)
- Added Public IP and outbound rules in LB module [#87243](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/87243)
- Create Azure Monitor Module [#87266](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/87266)
- BaseInfrastructure - Create examples directory with sample code [#71742](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71742)
- MySQLDatabase - Create examples directory with sample code [#75896](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/75896)
- AzureSQLDatabase - Create examples directory with sample code [#81733](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81733)
- CosmosDB - Create examples directory with sample code [#81734](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81734)
- Ability to pass a custom data script from the VMSS jumpstart kit [#71435](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71435)
- Ability to pass a custom data script from the VM jumpstart kit [#75585](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/75585)
- Azure Kubernetes Service module for jumpstart-aks [#24092](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/24092)

### Changed

- Override default storage diagnostics config in VM/VMSS [#88965](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/88965)
- Enable Large File Shares In SA Module [#89826](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/89826)
- Refactor Azure Monitor to accept resource_ids as an input from VM/VMSS output map [#89852](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/89852)

## [0.3.0] - 2020-05-07

### Added

- Create Application Insights module [#80610](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/80610)
- Remove PaasDB naming helpers (only user defined) [#72020](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/72020)
- PaasDB Separate DB providers into their own modules [#71745](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71745)
- Added Disk Encryption set for VM [#80977](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/80977)
- Added Network watcher extension to VM and VMSS module[#71746](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/71746)
- Added Disk Encryption set for VMSS[#59512](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/59512)
- Set Backup Policy For VM [#75678](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/75678)
- Create Recovery Vault module [#76284](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/76284)
- Added Vnet peering for Virtual networks [#52314](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/52314)

### Changed

- Removed references to VP Tower [#82735](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/82735)
- Removed $repoPath in favour of $Build.Repository.Name [#82276](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/82276)
- Remove "-arecord" from DNS name [#81666](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81666)
- Refactor VM or VMSS to attach specific load balancer backend pool [#82282](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/82282)
- Refactor VNet Peering [#81593](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/81593)
- KeyVault diagnostics should go to a storage account [#80468](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/80468)
- Refactor Load Balancer Module to support multiple Frontend IP's [#76289](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/76289)

## [0.2.0] - 2020-04-21

### Added

- Added customer managed key encryption for storage account [#50482](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/50482)
- Added key vault access policies to the storage MSI [#55871](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/55871)
- Enabled purge protection on key vault and set both purge protection and soft-delete to true by default [#70204](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/70204)
- Added PLS Terraform Module [#53447](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/53447)
- Enabled VMSS MSI identity & created KV access policy for VMSS Identity [#53437](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/53437)
- Added a publish pipeline artifact task to the Image Builder pipeline, publishing the Image ID created as a terraform .tfvars file for the next stage to consume [#7273](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/7273)
- Added a download pipeline artifact task to the Terraform pipeline to consume the generated image id (optional) [#7273](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/7273)
- Enable firewall on storage accounts [#43428](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43428)

### Changed

- Private Endpoints to trigger on resource type creation [#35855](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/35855)
- Correct 01,02,03,etc file names in VMSS, VM, BaseInfra [#53719](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/53719)
- Change Private Endpoint names in PE module [#43430](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43430)
- Rename MSSQL to AzureSQL in PaaS module [#43434](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43434)
- Refactored Existing Storage account TF module to multiple storage account [#43431](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/43431)
- Enable SQL firewall [#43435](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43435)
- Load Balancer naming convention changed to user defined [#43424](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43424)
- User must provide unique Log Analytics and Storage Account name for base infrastructure [#59207](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/59207)
- User must provide the names of the SPN for the VP tower subscription and the application SPN as well as the object ID for the application SPN in order to access terraform state in VP subscription and deploy resources to application subscription [#24109](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/24109)
- Bumped up Packer task version used on Image Builder to v1.5.1 [#33642](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/33642)
- User must provide unique Keyvault name instead of TF adjusting name to ensure unique [#57893](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/57893)
- Refactored VM Module and Resolved naming convention issue for VM and VMSS Module [#51432](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/51432)
- Stage.yaml in kits runs as an one job, which means Terraform.yaml is only tasks [#43423](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43423)
- Vnets names are now user defined without TF adding appending to the name [#43437](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/43437)
- Resolved VMSS timeout issue in pipeline [#47655](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/47655)
- Changes to the VM module include accepting an image_id variable when creating a Linux VM from a jumpstart kit either manually or generated from Image Builder. [#7273](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/7273)

### Removed

- AZ CLI Task that would Push the image version to a Shared Image Gallery, this is being done by the Packer task instead [#33642](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/33642)

## [0.1.0] - 2020-03-23

### Added

- Initial release

[unreleased]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library
[0.1.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.1
[0.2.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.2.0
[0.3.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.3.0
[0.4.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.4.0
[0.4.1]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.4.1
[0.5.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.5.0
[0.5.1]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.5.1
[0.5.2]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.5.2
[0.5.3]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.5.3
[0.5.4]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.5.4
[0.5.5]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.5.5
[0.6.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.6.0
[0.7.0]: https://dev.azure.com/ATTDevOps/ATT%20Cloud/_git/common-library?version=GTv0.7.0
