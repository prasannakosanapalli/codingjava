resource_group_name = "resource_group_name"

linux_vms = {
  vm1 = {
    name                             = "nginxvm"
    vm_size                          = "Standard_DS1_v2"
    assign_identity                  = true
    avaialability_set_key            = "av1"
    vm_nic_keys                      = ["nic1", "nic2"]
    lb_backend_pool_names            = ["nginxlbbackend"]
    lb_nat_rule_names                = ["rule1", "rule2"]
    app_security_group_names         = ["asg-src"]
    app_gateway_name                 = "jstartvm12062320gw"
    zone                             = "1"
    disable_password_authentication  = true
    source_image_reference_offer     = "RHEL"   # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher = "RedHat" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku       = "7-LVM"  # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version   = "Latest" # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer             
    storage_os_disk_caching          = "ReadWrite"
    managed_disk_type                = "Premium_LRS"
    disk_size_gb                     = null
    write_accelerator_enabled        = null
    recovery_services_vault_key      = "rsv1"
    enable_cmk_disk_encryption       = true                                   # set it to true if you want to enable disk encryption using customer managed key
    custom_data_path                 = "//Terraform//Scripts//CustomData.tpl" # Optional
    custom_data_args                 = { name = "VMandVMSS", destination = "EASTUS2", version = "1.0" }
    diagnostics_storage_config_path  = "//Terraform//Diagnostics//Config.json" # Optional
    custom_script = {
      commandToExecute   = "ls"
      scriptPath         = null
      scriptArgs         = null
      fileUris           = null
      storageAccountName = null
    }
    # custom_script = {
    #   commandToExecute   = "sh script1.sh"
    #   scriptPath         = null
    #   scriptArgs         = null
    #   fileUris           = ["https://jstartvm17062020s.blob.core.windows.net/script/script1.sh"]
    #   storageAccountName = "jstartvm17062020s"
    # }
    # custom_script = {
    #   commandToExecute   = null
    #   scriptPath         = "//Terraform//Scripts//script1.sh"
    #   scriptArgs         = null
    #   fileUris           = null
    #   storageAccountName = null
    # }
  }
}

administrator_user_name      = "vmadmin"
administrator_login_password = null # don't define it if you set disable_password_authentication to true

# managed data disks
managed_data_disks = {
  disk1 = {
    disk_name                 = "diskvm2"
    vm_key                    = "vm1"
    lun                       = 10
    storage_account_type      = "Standard_LRS"
    disk_size                 = "1024"
    caching                   = "None"
    write_accelerator_enabled = false
    os_type                   = "Linux"
    create_option             = null
    source_resource_id        = null
  }
}

availability_sets = {
  av1 = {
    name                         = "avsetfirst"
    platform_update_domain_count = 3
    platform_fault_domain_count  = 3
  }
}

linux_vm_nics = {
  nic1 = {
    name                          = "nic1"
    subnet_name                   = "appsubnet"
    internal_dns_name_label       = "testnew2020"
    enable_ip_forwarding          = false
    enable_accelerated_networking = false
    dns_servers                   = []
    nic_ip_configurations = [
      {
        name      = "nic1"
        static_ip = null
      }
    ]
  },
  nic2 = {
    name                          = "nic2"
    subnet_name                   = "appsubnet"
    internal_dns_name_label       = "testapp2020"
    enable_ip_forwarding          = false
    enable_accelerated_networking = false
    dns_servers                   = []
    nic_ip_configurations = [
      {
        name      = "nic2"
        static_ip = null
      }
    ]
  }
}


# Example  variable declaration for windows VM
windows_vms = {
  vm1 = {
    name                             = "windowsvm"
    vm_size                          = "Standard_DS1_v2"
    assign_identity                  = true
    lb_backend_pool_name             = "nginxlbbackend"
    zone                             = "1"
    subnet_name                      = "loadbalancer"
    source_image_reference_offer     = "WindowsServer"
    source_image_reference_publisher = "MicrosoftWindowsServer"
    source_image_reference_sku       = "2016-Datacenter"
    source_image_reference_version   = "Latest"
    storage_os_disk_caching          = "ReadWrite"
    managed_disk_type                = "Premium_LRS"
    disk_size_gb                     = null
    write_accelerator_enabled        = null
    internal_dns_name_label          = null
    enable_ip_forwarding             = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking    = null # set it to true if you want to enable accelerated networking
    dns_servers                      = null
    static_ip                        = null
    disk_encryption_set_id           = null
    custom_data_path                 = "//Terraform//Scripts//CustomData.tpl" # Optional
    custom_data_args                 = { name = "VMandVMSS", destination = "EASTUS2", version = "1.0" }
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
