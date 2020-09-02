variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Application Security Group components."
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
}

variable "application_security_groups" {
  type = map(object({
    name = string
  }))
  description = "Map containing Application Security Group details"
}
