locals {
  // Here you can define module metadata
  definitions = {
    tags = { ManagedBy = "Terraform" }
    resource_timeouts = {
      azurerm_postgresql_flexible_server = {
        create = "30m"
        read   = "5m"
        update = "30m"
        delete = "30m"
      }
      azurerm_postgresql_flexible_server_database = {
        create = "30m"
        read   = "5m"
        delete = "30m"
      }
    }
  }
}