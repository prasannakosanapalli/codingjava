# #############################################################################
# # OUTPUTS App Service Plans and App Services
# #############################################################################

output "app_services" {
  value       = { for k, b in azurerm_app_service.this : k => b }
  description = "Map output of the App Services"
}

output "app_service_plans" {
  value       = { for k, b in azurerm_app_service_plan.this : k => b }
  description = "Map output of the App Service Plans"
}
