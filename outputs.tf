output "postgresql_flexible_server" {
  description = "The full azurerm_postgresql_flexible_server resource object. Access computed attributes such as .id and .fqdn via this output."
  sensitive   = true
  value       = azurerm_postgresql_flexible_server.this
}

output "postgresql_flexible_server_databases" {
  description = "Map of azurerm_postgresql_flexible_server_database resource objects keyed by database name (matching var.databases keys)."
  value       = azurerm_postgresql_flexible_server_database.this
}
