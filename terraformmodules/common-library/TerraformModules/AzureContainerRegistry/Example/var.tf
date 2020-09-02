variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Azure Container Registry."
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Container Registry resource, in addition to the resource group tags."
}

# -
# - Azure Container Registry
# -
variable "name" {
  description = "Azure Container Registery Name"
  type        = string
}

variable "sku" {
  description = "Azure Container Registery SKU. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Premium"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled."
  type        = bool
  default     = false
}

variable "georeplication_locations" {
  description = "A list of Azure locations where the container registry should be geo-replicated."
  type        = list(string)
  default     = null
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "Specifies the list of subnet id's from which requests will match the netwrok rule."
  default     = null
}
