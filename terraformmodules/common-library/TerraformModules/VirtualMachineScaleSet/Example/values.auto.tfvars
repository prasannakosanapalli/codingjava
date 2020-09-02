resource_group_name = "resource_group_name"

vmss = {
  vm1 = {
    name = "jstartvmss"
    storage_profile_data_disks = [
      {
        lun                       = 0
        caching                   = "ReadWrite"
        disk_size_gb              = 32
        managed_disk_type         = "Standard_LRS"
        write_accelerator_enabled = null
      }
    ]
    subnet_name                        = "proxy"
    lb_backend_pool_names              = ["jstartlbbackend", "jstartlbbackendpublic"]
    lb_nat_pool_names                  = ["pool1"]
    app_security_group_names           = ["asg-src"]
    app_gateway_name                   = "jstartvmss15062020g-1"
    lb_probe_name                      = "jstartlbrule"
    zones                              = ["1", "2"] # Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line if mutli zone is enabled with LB, LB has to be standard
    vm_size                            = "Standard_DS1_v2"
    enable_ip_forwarding               = false
    assign_identity                    = true
    enable_rolling_upgrade             = true
    rolling_upgrade_policy             = null
    instances                          = 1
    disable_password_authentication    = true
    source_image_reference_offer       = "RHEL"
    source_image_reference_publisher   = "RedHat"
    source_image_reference_sku         = "7-LVM"
    source_image_reference_version     = "Latest"
    storage_os_disk_caching            = "ReadWrite"
    managed_disk_type                  = "Premium_LRS"
    disk_size_gb                       = null
    write_accelerator_enabled          = null
    enable_default_auto_scale_settings = null
    enable_accelerated_networking      = null
    enable_ip_forwarding               = null
    enable_cmk_disk_encryption         = true
    custom_data_path                   = "//Terraform//Scripts//CustomData.tpl" #Optional
    custom_data_args                   = { name = "VMandVMSS", destination = "EASTUS2", version = "1.0" }
    diagnostics_storage_config_path    = "//Terraform//Diagnostics//Config.json" #Optional
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

administrator_user_name      = "vmssadmin"
administrator_login_password = "test1234" # define this as 'null' if you are not using password authentication for the VMSS.

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}


# custom_auto_scale_settings

custom_auto_scale_settings = {
  cs1 = {
    name              = "autoscale1"
    vmss_key          = "vm1"
    profile_name      = "test"
    default_instances = "2"
    minimum_instances = "1"
    maximum_instances = "3"
    rule = [
      {
        # metric rule to increase the instances   
        metric_name      = "Percentage CPU"
        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT5M"
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = "75"
        direction        = "Increase"
        type             = "ChangeCount"
        value            = "1"
        cooldown         = "PT1M"
      },
      {
        # metric rule to decrease the instances   
        metric_name      = "Percentage CPU"
        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT5M"
        time_aggregation = "Average"
        operator         = "LessThan"
        threshold        = "10"
        direction        = "Decrease"
        type             = "ChangeCount"
        value            = "1"
        cooldown         = "PT1M"
      }
    ]
  }
}
