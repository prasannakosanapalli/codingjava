data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.app_security_groups_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - Application Security Groups
# -
resource "azurerm_application_security_group" "this" {
  for_each            = var.application_security_groups
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = local.tags
}

resource "null_resource" "dependency_asg" {
  depends_on = [azurerm_application_security_group.this]
}
