resource_group_name = "resource_group_name" # "<resource_group_name>"

name                     = "containerregistry0720" # container_name
sku                      = "Premium"               # SKU for container registry
georeplication_locations = ["East US"]             # list of geo-replicated azure locations
admin_enabled            = true                    # if(admin user is enabled) then set this to <true> otherwise <false>
allowed_subnet_ids       = null                    # list of subnet id's from which requests will match the netwrok rule

additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
