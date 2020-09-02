module "ResourceGroup" {
  source              = "../../common-library/TerraformModules/ResourceGroup"
  location            = var.location
  resource_group_name = var.name
  rg_additional_tags  = var.additional_tags
}
