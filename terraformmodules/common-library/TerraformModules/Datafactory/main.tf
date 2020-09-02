data "azurerm_resource_group" "this" {
  name = var.resource_group_name   
}

resource "azurerm_data_factory" "this" {
  for_each            = var.data_factory
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : list(lookup(each.value, "assign_identity", false))
    content {
      type = "SystemAssigned"
    }
  }
  
  dynamic "vsts_configuration" {
   for_each        = lookup(each.value , "vsts_configuration" , null) == null ? [] : [lookup(each.value , "vsts_configuration", null)]
   content {
   account_name    = vsts_configuration.value.account_name
   branch_name     = vsts_configuration.value.branch_name
   project_name    = vsts_configuration.value.project_name
   repository_name = vsts_configuration.value.repository_name
   root_folder     = vsts_configuration.value.root_folder
   tenant_id       = vsts_configuration.value.tenant_id    
   }
  }
   
   }