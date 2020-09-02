resource_group_name = "<resource_group_name>"

zones = ["1"]

load_balancers = {
  loadbalancer1 = {
    name = "nginxlb"
    sku  = "Standard"
    frontend_ips = [
      {
        name        = "nginxlbfrontend" # <"frontend_ip_config_name">
        subnet_name = "loadbalancer"    # <"subnet_name">
        static_ip   = null              # "10.0.1.4" #(Optional) Set null to get dynamic IP 
        zones       = null
      },
      {
        name        = "nginxlbfrontend1" # <"frontend_ip_config_name">
        subnet_name = "loadbalancer"     # <"subnet_name">
        static_ip   = null               # "10.0.1.4" #(Optional) Set null to get dynamic IP
        zones       = null
      }
    ]
    backend_pool_names = ["nginxlbbackend", "nginxlbbackend1"]
    enable_public_ip   = false # set this to true to if you want to create public load balancer
    public_ip_name     = null  # custom name for public ip 
  }
}

load_balancer_rules = {
  loadbalancerrules1 = {
    name                      = "nginxlbrule"
    lb_key                    = "loadbalancer1"
    frontend_ip_name          = "nginxlbfrontend"
    backend_pool_name         = "nginxlbbackend"
    lb_protocol               = null
    lb_port                   = 22
    probe_port                = 22
    backend_port              = 22
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  },
  # HA port loadbalancer rule
  loadbalancerrules2 = {
    name                      = "springboot-lb-rule-ha"
    lb_key                    = "loadbalancer1"
    frontend_ip_name          = "springbootlbfrontend1"
    backend_pool_name         = "springbootlbbackend1"
    lb_protocol               = "All"
    lb_port                   = 0
    probe_port                = "22"
    backend_port              = 0
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  }
}

load_balancer_nat_rules = {
  loadbalancernatrules1 = {
    name                    = "ngnixlbnatrule"
    lb_key                  = "loadbalancer1"
    frontend_ip_name        = "nginxlbfrontend"
    lb_port                 = 80
    backend_port            = 22
    idle_timeout_in_minutes = 5
  }
}

lb_outbound_rules = {
  rule1 = {
    name                            = "test"
    lb_key                          = "loadbalancer1"
    protocol                        = "Tcp"
    backend_pool_name               = "nginxlbbackend"
    allocated_outbound_ports        = null
    frontend_ip_configuration_names = ["nginxlbfrontend"]
  }
}

load_balancer_nat_pools = {
  nat_pool1 = {
    name             = "pool1"
    lb_key           = "loadbalancer1"
    frontend_ip_name = "nginxlbfrontend"
    lb_port_start    = "1433"
    lb_port_end      = "1444"
    backend_port     = "8080"
  }
}
