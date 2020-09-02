resource_group_name = "resource_group_name" # "<resource_group_name>"

key_vault_resource_group         = "appgw-rg"
key_vault_name                   = "appgwkv"
diagnostics_storage_account_name = "<diagnostics_storage_account_name>"

application_gateways = {
  #- Application Gateway with PathBasedRouting Routing Rule
  "appgw1" = {
    name         = "example-appgateway1"
    zones        = ["1", "2", "3"]
    enable_http2 = true
    waf_key      = "waf1"
    sku = {
      name     = "WAF_v2"
      tier     = "WAF_v2"
      capacity = 2
    }
    gateway_ip_configurations = [{
      name        = "my-gateway-ip-configuration"
      subnet_name = "applicationgateway"
    }]
    frontend_ports = [
      {
        name = "example-appgateway-feport"
        port = 443
      }
    ]
    frontend_ip_configurations = [
      {
        name             = "example-appgateway-feip"
        subnet_name      = "applicationgateway"
        static_ip        = null
        enable_public_ip = true
      }
    ]
    backend_address_pools = [
      {
        name         = "example-appgateway-beap"
        fqdns        = null
        ip_addresses = null
      },
      {
        name         = "path-appgateway-beap"
        fqdns        = null
        ip_addresses = null
      }
    ]
    backend_http_settings = [
      {
        name                                = "example-appgateway-be-htst"
        path                                = "/"
        protocol                            = "Https"
        port                                = 443
        cookie_based_affinity               = "Enabled"
        request_timeout                     = null
        probe_name                          = "chef-probe"
        host_name                           = "att.com"
        pick_host_name_from_backend_address = false
      },
      {
        name                                = "path-appgateway-be-htst"
        path                                = "/"
        protocol                            = "Https"
        port                                = 443
        cookie_based_affinity               = "Enabled"
        request_timeout                     = null
        probe_name                          = "docker-probe"
        host_name                           = "att.com"
        pick_host_name_from_backend_address = false
      }
    ]
    http_listeners = [
      {
        name                           = "example-appgateway-httplstn"
        frontend_ip_configuration_name = "example-appgateway-feip"
        frontend_port_name             = "example-appgateway-feport"
        ssl_certificate_name           = "appgwclientcert"
        sni_required                   = false
        protocol                       = "Https"
        listener_type                  = "Basic"
        host_name                      = null
        host_names                     = null
      },
      {
        name                           = "path-appgateway-httplstn"
        frontend_ip_configuration_name = "example-appgateway-feip"
        frontend_port_name             = "example-appgateway-feport"
        ssl_certificate_name           = "appgwclientcert"
        sni_required                   = true
        protocol                       = "Https"
        listener_type                  = "MultiSite"
        host_name                      = "att.com"
        host_names                     = null
      },
      {
        name                           = "redirect-appgateway-httplstn"
        frontend_ip_configuration_name = "example-appgateway-feip"
        frontend_port_name             = "example-appgateway-feport"
        ssl_certificate_name           = "appgwclientcert"
        sni_required                   = true
        protocol                       = "Https"
        listener_type                  = "MultiSite"
        host_name                      = "attdev.com"
        host_names                     = null
      }
    ]
    request_routing_rules = [
      {
        name                        = "example-appgateway-rqrt"
        rule_type                   = "Basic"
        listener_name               = "example-appgateway-httplstn"
        backend_address_pool_name   = "example-appgateway-beap"
        backend_http_settings_name  = "example-appgateway-be-htst"
        redirect_configuration_name = null
        url_path_map_name           = null
        rewrite_rule_set_name       = null
      },
      {
        name                        = "path-appgateway-rqrt"
        rule_type                   = "PathBasedRouting"
        listener_name               = "path-appgateway-httplstn"
        backend_address_pool_name   = null                      #"path-appgateway-beap"
        backend_http_settings_name  = null                      #"path-appgateway-be-htst"
        redirect_configuration_name = "path-appgateway-rconfig" #null
        url_path_map_name           = "path-appgateway-upm"
        rewrite_rule_set_name       = null
      }
    ]
    url_path_maps = [{
      name                                = "path-appgateway-upm"
      default_backend_http_settings_name  = null                      #"path-appgateway-be-htst"
      default_backend_address_pool_name   = null                      #"path-appgateway-beap"
      default_redirect_configuration_name = "path-appgateway-rconfig" #null
      default_rewrite_rule_set_name       = null
      path_rules = [{
        name                        = "path-appgateway-pr"
        paths                       = ["/*"]
        backend_http_settings_name  = null                      #"path-appgateway-be-htst"
        backend_address_pool_name   = null                      #"path-appgateway-beap"
        redirect_configuration_name = "path-appgateway-rconfig" #null
        rewrite_rule_set_name       = null
      }]
    }]
    probes = [
      {
        name                                      = "chef-probe"
        path                                      = "/"
        host                                      = "eastus2-t-chef1.bf.sl.attcompute.com"
        protocol                                  = "Https"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      },
      {
        name                                      = "docker-probe"
        path                                      = "/"
        host                                      = "devpgm-uam.bf.sl.attcompute.com"
        protocol                                  = "Https"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      }
    ]
    redirect_configurations = [{
      name                 = "path-appgateway-rconfig"
      redirect_type        = null
      target_listener_name = "redirect-appgateway-httplstn"
      target_url           = null
      include_path         = null
      include_query_string = null
    }]
    rewrite_rule_sets                       = null
    disabled_ssl_protocols                  = null
    trusted_root_certificate_names          = ["appgwclientpfxcert"]
    ssl_certificate_names                   = ["appgwclientcercert"]
    key_vault_with_private_endpoint_enabled = true
  },
  #- Application Gateway with Basic Routing Rule
  "appgw2" = {
    name         = "example-appgateway2"
    zones        = ["1", "2", "3"]
    enable_http2 = true
    waf_key      = "waf1"
    sku = {
      name     = "WAF_v2"
      tier     = "WAF_v2"
      capacity = 2
    }
    gateway_ip_configurations = [{
      name        = "my-gateway-ip-configuration"
      subnet_name = "applicationgateway"
    }]
    frontend_ports = [
      {
        name = "example-appgateway-feport"
        port = 443
      }
    ]
    frontend_ip_configurations = [
      {
        name             = "example-appgateway-feip"
        subnet_name      = "applicationgateway"
        static_ip        = null
        enable_public_ip = true
      }
    ]
    backend_address_pools = [
      {
        name         = "example-appgateway-beap"
        fqdns        = null
        ip_addresses = null
      }
    ]
    backend_http_settings = [
      {
        name                                = "example-appgateway-be-htst"
        path                                = "/"
        protocol                            = "Https"
        port                                = 443
        cookie_based_affinity               = "Enabled"
        request_timeout                     = null
        probe_name                          = "chef-probe"
        host_name                           = "att.com"
        pick_host_name_from_backend_address = false
      }
    ]
    http_listeners = [
      {
        name                           = "example-appgateway-httplstn"
        frontend_ip_configuration_name = "example-appgateway-feip"
        frontend_port_name             = "example-appgateway-feport"
        ssl_certificate_name           = "appgwclientcert"
        protocol                       = "Https"
        sni_required                   = false
        listener_type                  = "Basic"
        host_name                      = null
        host_names                     = null
      }
    ]
    request_routing_rules = [
      {
        name                        = "example-appgateway-rqrt"
        rule_type                   = "Basic"
        listener_name               = "example-appgateway-httplstn"
        backend_address_pool_name   = "example-appgateway-beap"
        backend_http_settings_name  = "example-appgateway-be-htst"
        redirect_configuration_name = null
        url_path_map_name           = null
        rewrite_rule_set_name       = "example-appgateway-rwrs"
      }
    ]
    url_path_maps = null
    probes = [
      {
        name                                      = "chef-probe"
        path                                      = "/"
        host                                      = "eastus2-t-chef1.bf.sl.attcompute.com"
        protocol                                  = "Https"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      },
      {
        name                                      = "docker-probe"
        path                                      = "/"
        host                                      = "devpgm-uam.bf.sl.attcompute.com"
        protocol                                  = "Https"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      }
    ]
    rewrite_rule_sets = [{
      name = "example-appgateway-rwrs"
      rewrite_rules = [{
        name          = "example-appgateway-rwr"
        rule_sequence = 100
        conditions = [{
          variable    = "http_req_Authorization"
          pattern     = "^Bearer"
          ignore_case = true
          negate      = false
        }]
        request_header_configurations = [{
          header_name  = "X-Forwarded-For"
          header_value = "var_add_x_forwarded_for_proxy"
        }]
        response_header_configurations = [{
          header_name  = "Strict-Transport-Security"
          header_value = "max-age=31536000"
        }]
      }]
    }]
    redirect_configurations                 = null
    disabled_ssl_protocols                  = null
    trusted_root_certificate_names          = ["appgwclientpfxcert"]
    ssl_certificate_names                   = ["appgwclientcercert"]
    key_vault_with_private_endpoint_enabled = true
  }
}

waf_policies = {
  waf1 = {
    name = "example-wafpolicy"
    custom_rules = [{
      name      = "Rule1"
      priority  = 1
      rule_type = "MatchRule"
      action    = "Block"
      match_conditions = [{
        match_variables = [{
          variable_name = "RemoteAddr"
          selector      = null
        }]
        operator           = "IPMatch"
        negation_condition = false
        match_values       = ["192.168.1.0/24", "10.0.0.0/24"]
      }]
    }]
    policy_settings = {
      enabled = true
      mode    = "Prevention"
    }
    managed_rules = {
      exclusions = [{
        match_variable          = "RequestHeaderNames"
        selector                = "x-company-secret-header"
        selector_match_operator = "Equals"
      }]
      managed_rule_sets = [{
        type    = "OWASP"
        version = "3.1"
        rule_group_overrides = [{
          rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
          disabled_rules  = ["920300", "920440"]
        }]
      }]
    }
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
