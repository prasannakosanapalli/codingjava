resource_group_name = "resource_group_name" # "<resource_group_name>"

app_services = {
  as1 = {
    name                 = "linuxappservice"
    app_service_plan_key = "asp1"
    app_settings = {
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
      "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
    }
    client_affinity_enabled = null
    client_cert_enabled     = null
    enabled                 = null
    https_only              = null
    assign_identity         = null
    auth_settings           = null
    storage_accounts        = null
    backup                  = null
    connection_strings      = null
    site_config = {
      always_on                        = null
      app_command_line                 = null
      default_documents                = null
      dotnet_framework_version         = null
      ftps_state                       = null
      http2_enabled                    = null
      java_version                     = null
      java_container                   = null
      java_container_version           = null
      local_mysql_enabled              = null
      linux_fx_version                 = "DOCKER|appsvcsample/python-helloworld:latest"
      linux_fx_version_local_file_path = null
      windows_fx_version               = null
      managed_pipeline_mode            = null
      min_tls_version                  = null
      php_version                      = null
      python_version                   = null
      remote_debugging_enabled         = null
      remote_debugging_version         = null
      scm_type                         = null
      use_32_bit_worker_process        = null
      websockets_enabled               = null
      cors                             = null
      ip_restriction                   = null
    }
    logs = null
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
