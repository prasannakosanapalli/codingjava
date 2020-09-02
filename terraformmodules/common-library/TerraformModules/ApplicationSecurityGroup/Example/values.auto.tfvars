resource_group_name = "resource_group_name" # "<resource_group_name>"

application_security_groups = {
  asg1 = {
    name = "asg-src"
  },
  asg2 = {
    name = "asg-dest"
  }
}

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
