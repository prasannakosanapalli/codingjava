# -
# - Create Resource Group
# -
resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.rg_additional_tags
}
