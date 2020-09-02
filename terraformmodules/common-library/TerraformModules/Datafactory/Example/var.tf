variable "resource_group_name" {
 description = "name of the resource group"
}

variable "data_factory" {
    type = map(object({
     name                = string
     assign_identity     = bool
     vsts_configuration  = object({
     account_name        = string
     branch_name         = string
     project_name        = string
     repository_name     = string
     root_folder         = string
     tenant_id           = string     
     }) 

    }))
}