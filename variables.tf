variable "name" {
  description = "Name of the Azure PostgreSQL Flexible Server."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which the Azure PostgreSQL Flexible Server will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the PostgreSQL Flexible Server will be deployed."
  type        = string
}

variable "administrator_login" {
  description = "The administrator login name for the PostgreSQL Flexible Server."
  type        = string
}

variable "administrator_password" {
  description = "The administrator password for the PostgreSQL Flexible Server."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "sku_name" {
  description = "The SKU Name for the PostgreSQL Flexible Server. Format: <tier>_<family>_<size> (e.g. GP_Standard_D4s_v3, B_Standard_B1ms)."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgresql_version" {
  description = "The version of PostgreSQL Flexible Server to use. Possible values are 11, 12, 13, 14, 15, and 16."
  type        = string
  default     = "16"
}

variable "zone" {
  description = "The Availability Zone in which the PostgreSQL Flexible Server should be located. Possible values are 1, 2 and 3."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for the PostgreSQL Flexible Server. Defaults to true; set to false for private-only deployments."
  type        = bool
  default     = true
}

variable "create_mode" {
  description = "The creation mode of the PostgreSQL Flexible Server. Possible values are Default, GeoRestore, PointInTimeRestore, Replica, and Update."
  type        = string
  default     = "Default"

  validation {
    condition     = contains(["Default", "GeoRestore", "PointInTimeRestore", "Replica", "Update"], var.create_mode)
    error_message = "create_mode must be one of: Default, GeoRestore, PointInTimeRestore, Replica, Update."
  }
}

variable "source_server_id" {
  description = "The resource ID of the source PostgreSQL Flexible Server to be restored. Required when create_mode is GeoRestore, PointInTimeRestore, or Replica."
  type        = string
  default     = null
}

variable "point_in_time_restore_time_in_utc" {
  description = "The point-in-time to restore from, in RFC3339 format. Required when create_mode is PointInTimeRestore."
  type        = string
  default     = null
}

variable "replication_role" {
  description = "The replication role for the PostgreSQL Flexible Server. Possible values are None, Replica, and GeoAsyncReplica."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the PostgreSQL Flexible Server."
  type        = map(string)
  default     = {}
}

variable "backup" {
  description = "Backup configuration for the PostgreSQL Flexible Server."
  type = object({
    retention_days        = optional(number, 7)
    geo_redundant_enabled = optional(bool, false)
  })
  default = {}
}

variable "storage" {
  description = "Storage configuration for the PostgreSQL Flexible Server."
  type = object({
    mb                = optional(number, 32768)
    auto_grow_enabled = optional(bool, false)
    tier              = optional(string, null)
  })
  default = {}
}

variable "authentication" {
  description = "Authentication configuration for the PostgreSQL Flexible Server."
  type = object({
    active_directory_auth_enabled = optional(bool, false)
    password_auth_enabled         = optional(bool, true)
    tenant_id                     = optional(string, null)
  })
  default = {}
}

variable "high_availability" {
  description = "High availability configuration for the PostgreSQL Flexible Server. Set to null or use mode 'Disabled' to omit the block."
  type = object({
    mode                      = optional(string, "Disabled")
    standby_availability_zone = optional(string, null)
  })
  default = null
}

variable "maintenance_window" {
  description = "Maintenance window configuration. When null, the provider default (no custom window) applies. day_of_week: 0=Sunday through 6=Saturday."
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  default = null
}

variable "network" {
  description = "Network configuration for VNet-integrated deployments. Provides delegated_subnet_id and private_dns_zone_id for private connectivity. Use var.public_network_access_enabled to control public access independently."
  type = object({
    delegated_subnet_id = optional(string, null)
    private_dns_zone_id = optional(string, null)
  })
  default = null
}

variable "identity" {
  description = "Managed identity configuration for the PostgreSQL Flexible Server. Set to null or omit type to disable identity assignment."
  type = object({
    type         = optional(string, null)
    identity_ids = optional(list(string), [])
  })
  default = null
}

variable "customer_managed_key" {
  description = "Customer-managed key (CMK) configuration for data-at-rest encryption. Requires a UserAssigned managed identity. Set to null or omit key_vault_key_id to disable CMK."
  type = object({
    key_vault_key_id                     = optional(string, null)
    primary_user_assigned_identity_id    = optional(string, null)
    geo_backup_key_vault_key_id          = optional(string, null)
    geo_backup_user_assigned_identity_id = optional(string, null)
  })
  default = null
}

variable "databases" {
  description = "Map of PostgreSQL databases to create on the server. The map key is the database name. charset and collation default to UTF8 and en_US.utf8."
  type = map(object({
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_US.utf8")
  }))
  default = {}
}
