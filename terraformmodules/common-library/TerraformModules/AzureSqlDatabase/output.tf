# #############################################################################
# # OUTPUTS Azure SQL Server
# #############################################################################

output "azuresql_server_id" {
  value       = azurerm_mssql_server.this.id
  description = "The server id of Azure SQL Server"
}

output "azuresql_server_name" {
  value       = azurerm_mssql_server.this.name
  description = "The server name of Azure SQL Server"
}

output "azuresql_fqdn" {
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
  description = "The fully qualified domain name of the Azure SQL Server"
}

output "azuresql_databases_names" {
  value       = [for x in azurerm_mssql_database.this : x.name]
  description = "List of all Azure SQL database resource names"
}

output "azuresql_databases_ids" {
  value       = [for x in azurerm_mssql_database.this : x.id]
  description = "The list of all Azure SQL database resource ids"
}
