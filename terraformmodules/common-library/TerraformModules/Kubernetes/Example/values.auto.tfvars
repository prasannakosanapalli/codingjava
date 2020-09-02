resource_group_name = "resource_group_name" # "<resource_group_name>"

# - AKS
aks_clusters = {
  "aks1" = {
    name                            = "jstartaks07042020"
    sku_tier                        = "Free"
    dns_prefix                      = "jstaraks07042020"
    kubernetes_version              = "1.16.8"
    docker_bridge_cidr              = "172.17.0.1/16"
    service_address_range           = "10.0.16.0/24"
    dns_ip                          = "10.0.16.2"
    rbac_enabled                    = false
    cmk_enabled                     = true
    assign_identity                 = true
    admin_username                  = "aksadminuser"
    auto_scaler_profile             = null
    load_balancer_profile           = null
    network_plugin                  = "azure"
    network_policy                  = "azure" #"calico" 
    pod_cidr                        = null    #Allowed if network_plugin <> "azure"
    api_server_authorized_ip_ranges = null    #["73.140.245.0/24"]
    aks_default_pool = {
      name                = "jstartaks"
      vm_size             = "Standard_B2ms"
      availability_zones  = [1, 2, 3]
      enable_auto_scaling = true
      max_pods            = 30
      os_disk_size_gb     = 30
      subnet_name         = "akscluster"
      node_count          = 1
      min_count           = 1
      max_count           = 1
    }
  }
}

aks_extra_node_pools = {}

# - Private DNS for ADO agent connectivity
ado_aks_private_endpoint_name   = "jstartaks07042020-aks"
ado_subnet_name                 = "eastus2-msft-devops-vnet-snet"
ado_vnet_name                   = "eastus2-msft-devops-vnet"
ado_aks_private_connection_name = "ado-to-aks"
ado_resource_group_name         = "msft-eastus2-devops-rg"
ado_private_dns_vnet_link_name  = "jstartaks07042020-aks"

# Azure container registry 
acr_name                    = "msftdevopsacr"
acr_pe_name                 = "jstartaks07042020-acr"
pe_acr_record_name          = "msftdevopsacr"
pe_acr_vnetlink_name        = "jstartaks07042020-acr"
acr_private_connection_name = "aks-to-acr"

# RBAC
# - IF AD integration is set to true the following attributes are required. The   
ad_enabled = false

###  Start AD integration config variables
# Base Key Vault where the information will client app id , server app id and 
mgmt_key_vault_name = "base-aks"
mgmt_key_vault_rg   = "base-infra-aks"

# secret name of objects stored in the key vault    
aks_client_app_id     = "aks-client-app-id"
aks_server_app_id     = "aks-server-app-id"
aks_server_app_secret = "aks-server-app-secret"
###  END AD integration config variables 

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
