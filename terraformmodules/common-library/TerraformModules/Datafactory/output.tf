output "data_factory_id" {
  value = [for x in azurerm_data_factory.this : x.id]
}

output "data_factory_map" {
  value = { for x in azurerm_data_factory.this : x.name => x.id }
}