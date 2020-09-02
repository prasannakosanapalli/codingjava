# #############################################################################
# # OUTPUTS PostgreSql Server and PostgreSql Database
# #############################################################################

output "postgresql_names" {
  value = [for k in azurerm_postgresql_server.this : k.name]
}

output "postgresql_id" {
  value = [for k in azurerm_postgresql_server.this : k.id]
}