/*
 * # wanted-cloud/terraform-azure-postgresql-server
 *
 * Simple Terraform building block wrapper around Azure PostgreSQL Flexible Server and related resources.
 */

resource "azurerm_postgresql_flexible_server" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sku_name = var.sku_name
  version  = var.postgresql_version
  zone     = var.zone

  create_mode                       = var.create_mode
  source_server_id                  = var.source_server_id
  point_in_time_restore_time_in_utc = var.point_in_time_restore_time_in_utc
  replication_role                  = var.replication_role

  # Network — top-level attributes in azurerm >= 4.x (network block was removed)
  delegated_subnet_id           = var.network != null ? var.network.delegated_subnet_id : null
  private_dns_zone_id           = var.network != null ? var.network.private_dns_zone_id : null
  public_network_access_enabled = var.public_network_access_enabled

  backup_retention_days        = var.backup.retention_days
  geo_redundant_backup_enabled = var.backup.geo_redundant_enabled

  # Storage — top-level attributes in azurerm >= 4.x (storage block was removed)
  storage_mb        = var.storage.mb
  auto_grow_enabled = var.storage.auto_grow_enabled
  storage_tier      = var.storage.tier

  authentication {
    active_directory_auth_enabled = var.authentication.active_directory_auth_enabled
    password_auth_enabled         = var.authentication.password_auth_enabled
    tenant_id                     = var.authentication.tenant_id
  }

  dynamic "high_availability" {
    for_each = (
      var.high_availability != null &&
      var.high_availability.mode != "Disabled"
    ) ? [var.high_availability] : []

    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []

    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  dynamic "identity" {
    for_each = (
      var.identity != null &&
      var.identity.type != null
    ) ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = (
      var.customer_managed_key != null &&
      var.customer_managed_key.key_vault_key_id != null
    ) ? [var.customer_managed_key] : []

    content {
      key_vault_key_id                     = customer_managed_key.value.key_vault_key_id
      primary_user_assigned_identity_id    = customer_managed_key.value.primary_user_assigned_identity_id
      geo_backup_key_vault_key_id          = customer_managed_key.value.geo_backup_key_vault_key_id
      geo_backup_user_assigned_identity_id = customer_managed_key.value.geo_backup_user_assigned_identity_id
    }
  }

  tags = var.tags

  timeouts {
    create = try(local.metadata.resource_timeouts["azurerm_postgresql_flexible_server"]["create"], local.metadata.resource_timeouts["default"]["create"])
    read   = try(local.metadata.resource_timeouts["azurerm_postgresql_flexible_server"]["read"], local.metadata.resource_timeouts["default"]["read"])
    update = try(local.metadata.resource_timeouts["azurerm_postgresql_flexible_server"]["update"], local.metadata.resource_timeouts["default"]["update"])
    delete = try(local.metadata.resource_timeouts["azurerm_postgresql_flexible_server"]["delete"], local.metadata.resource_timeouts["default"]["delete"])
  }
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  for_each = var.databases

  name      = each.key
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = each.value.charset
  collation = each.value.collation

  timeouts {
    create = try(local.metadata.resource_timeouts["azurerm_postgresql_flexible_server_database"]["create"], local.metadata.resource_timeouts["default"]["create"])
    read   = try(local.metadata.resource_timeouts["azurerm_postgresql_flexible_server_database"]["read"], local.metadata.resource_timeouts["default"]["read"])
    delete = try(local.metadata.resource_timeouts["azurerm_postgresql_flexible_server_database"]["delete"], local.metadata.resource_timeouts["default"]["delete"])
  }
}
