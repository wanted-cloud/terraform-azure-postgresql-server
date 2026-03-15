<!-- BEGIN_TF_DOCS -->
# wanted-cloud/terraform-azure-postgresql-server

Simple Terraform building block wrapper around Azure PostgreSQL Flexible Server and related resources.

## Table of contents

- [Requirements](#requirements)
- [Providers](#providers)
- [Variables](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)
- [Security Considerations](#security-considerations)
- [Usage](#usage)
- [Contributing](#contributing)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.11)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 4.20.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (4.64.0)

## Required Inputs

The following input variables are required:

### <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login)

Description: The administrator login name for the PostgreSQL Flexible Server.

Type: `string`

### <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password)

Description: The administrator password for the PostgreSQL Flexible Server.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the PostgreSQL Flexible Server will be deployed.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the Azure PostgreSQL Flexible Server.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Name of the resource group in which the Azure PostgreSQL Flexible Server will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_authentication"></a> [authentication](#input\_authentication)

Description: Authentication configuration for the PostgreSQL Flexible Server.

Type:

```hcl
object({
    active_directory_auth_enabled = optional(bool, false)
    password_auth_enabled         = optional(bool, true)
    tenant_id                     = optional(string, null)
  })
```

Default: `{}`

### <a name="input_backup"></a> [backup](#input\_backup)

Description: Backup configuration for the PostgreSQL Flexible Server.

Type:

```hcl
object({
    retention_days        = optional(number, 7)
    geo_redundant_enabled = optional(bool, false)
  })
```

Default: `{}`

### <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode)

Description: The creation mode of the PostgreSQL Flexible Server. Possible values are Default, GeoRestore, PointInTimeRestore, Replica, and Update.

Type: `string`

Default: `"Default"`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: Customer-managed key (CMK) configuration for data-at-rest encryption. Requires a UserAssigned managed identity. Set to null or omit key\_vault\_key\_id to disable CMK.

Type:

```hcl
object({
    key_vault_key_id                     = optional(string, null)
    primary_user_assigned_identity_id    = optional(string, null)
    geo_backup_key_vault_key_id          = optional(string, null)
    geo_backup_user_assigned_identity_id = optional(string, null)
  })
```

Default: `null`

### <a name="input_databases"></a> [databases](#input\_databases)

Description: Map of PostgreSQL databases to create on the server. The map key is the database name. charset and collation default to UTF8 and en\_US.utf8.

Type:

```hcl
map(object({
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_US.utf8")
  }))
```

Default: `{}`

### <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability)

Description: High availability configuration for the PostgreSQL Flexible Server. Set to null or use mode 'Disabled' to omit the block.

Type:

```hcl
object({
    mode                      = optional(string, "Disabled")
    standby_availability_zone = optional(string, null)
  })
```

Default: `null`

### <a name="input_identity"></a> [identity](#input\_identity)

Description: Managed identity configuration for the PostgreSQL Flexible Server. Set to null or omit type to disable identity assignment.

Type:

```hcl
object({
    type         = optional(string, null)
    identity_ids = optional(list(string), [])
  })
```

Default: `null`

### <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window)

Description: Maintenance window configuration. When null, the provider default (no custom window) applies. day\_of\_week: 0=Sunday through 6=Saturday.

Type:

```hcl
object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
```

Default: `null`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: Metadata definitions for the module, this is optional construct allowing override of the module defaults defintions of validation expressions, error messages, resource timeouts and default tags.

Type:

```hcl
object({
    resource_timeouts = optional(
      map(
        object({
          create = optional(string, "30m")
          read   = optional(string, "5m")
          update = optional(string, "30m")
          delete = optional(string, "30m")
        })
      ), {}
    )
    tags                     = optional(map(string), {})
    validator_error_messages = optional(map(string), {})
    validator_expressions    = optional(map(string), {})
  })
```

Default: `{}`

### <a name="input_network"></a> [network](#input\_network)

Description: Network configuration for VNet-integrated deployments. Provides delegated\_subnet\_id and private\_dns\_zone\_id for private connectivity. Use var.public\_network\_access\_enabled to control public access independently.

Type:

```hcl
object({
    delegated_subnet_id = optional(string, null)
    private_dns_zone_id = optional(string, null)
  })
```

Default: `null`

### <a name="input_point_in_time_restore_time_in_utc"></a> [point\_in\_time\_restore\_time\_in\_utc](#input\_point\_in\_time\_restore\_time\_in\_utc)

Description: The point-in-time to restore from, in RFC3339 format. Required when create\_mode is PointInTimeRestore.

Type: `string`

Default: `null`

### <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version)

Description: The version of PostgreSQL Flexible Server to use. Possible values are 11, 12, 13, 14, 15, and 16.

Type: `string`

Default: `"16"`

### <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled)

Description: Whether or not public network access is allowed for the PostgreSQL Flexible Server. Defaults to true; set to false for private-only deployments.

Type: `bool`

Default: `true`

### <a name="input_replication_role"></a> [replication\_role](#input\_replication\_role)

Description: The replication role for the PostgreSQL Flexible Server. Possible values are None, Replica, and GeoAsyncReplica.

Type: `string`

Default: `null`

### <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name)

Description: The SKU Name for the PostgreSQL Flexible Server. Format: <tier>\_<family>\_<size> (e.g. GP\_Standard\_D4s\_v3, B\_Standard\_B1ms).

Type: `string`

Default: `"B_Standard_B1ms"`

### <a name="input_source_server_id"></a> [source\_server\_id](#input\_source\_server\_id)

Description: The resource ID of the source PostgreSQL Flexible Server to be restored. Required when create\_mode is GeoRestore, PointInTimeRestore, or Replica.

Type: `string`

Default: `null`

### <a name="input_storage"></a> [storage](#input\_storage)

Description: Storage configuration for the PostgreSQL Flexible Server.

Type:

```hcl
object({
    mb                = optional(number, 32768)
    auto_grow_enabled = optional(bool, false)
    tier              = optional(string, null)
  })
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A map of tags to assign to the PostgreSQL Flexible Server.

Type: `map(string)`

Default: `{}`

### <a name="input_zone"></a> [zone](#input\_zone)

Description: The Availability Zone in which the PostgreSQL Flexible Server should be located. Possible values are 1, 2 and 3.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_postgresql_flexible_server"></a> [postgresql\_flexible\_server](#output\_postgresql\_flexible\_server)

Description: The full azurerm\_postgresql\_flexible\_server resource object. Access computed attributes such as .id and .fqdn via this output.

### <a name="output_postgresql_flexible_server_databases"></a> [postgresql\_flexible\_server\_databases](#output\_postgresql\_flexible\_server\_databases)

Description: Map of azurerm\_postgresql\_flexible\_server\_database resource objects keyed by database name (matching var.databases keys).

## Resources

The following resources are used by this module:

- [azurerm_postgresql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) (resource)
- [azurerm_postgresql_flexible_server_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

## Security Considerations

Review the following defaults before deploying to production. The module ships with permissive defaults to minimise friction in dev/test environments — tighten these for any internet-facing or regulated workload.

### Public Network Access (Medium)

`public_network_access_enabled` defaults to `true`, which exposes the server endpoint to the internet. For production deployments set `public_network_access_enabled = false` and supply `var.network` with a delegated subnet and private DNS zone to enforce private-only connectivity.

### Authentication (Medium)

The default configuration enables password-only authentication (`authentication.password_auth_enabled = true`, `active_directory_auth_enabled = false`). For production workloads configure `active_directory_auth_enabled = true` and set `tenant_id` to your Entra ID tenant. Consider disabling `password_auth_enabled` entirely once all clients support Azure AD tokens.

### Backup (Medium)

`backup.geo_redundant_enabled` defaults to `false` — backup data is stored in a single region only. Enable for production workloads that require geographic redundancy. `backup.retention_days` defaults to `7` (the Azure minimum) — production workloads typically require 14–35 days depending on RPO requirements and compliance obligations.

### SKU

The default `sku_name = "B_Standard_B1ms"` is a Burstable tier intended for dev/test workloads only. Production workloads require at minimum a General Purpose tier (`GP_Standard_D*`) for consistent CPU performance, or Memory Optimised (`MO_Standard_E*`) for memory-intensive workloads.

### Encryption

By default Azure-managed keys are used for data-at-rest encryption. Customer-managed keys (CMK) can be configured via `var.customer_managed_key` — this requires a `UserAssigned` managed identity assigned via `var.identity`. CMK is recommended for workloads with strict data sovereignty or compliance requirements (e.g. PCI-DSS, HIPAA).

## Usage

> For more detailed examples navigate to `examples` folder of this repository.

Module was also published via Terraform Registry and can be used as a module from the registry.

```hcl
module "postgresql_server" {
  source  = "wanted-cloud/postgresql-server/azure"
  version = "x.y.z"
}
```

### Basic usage example

The minimal usage for the module is as follows:

```hcl
module "postgresql_server" {
  source = "../.."

  name                   = "psql-example-westeurope-001"
  resource_group_name    = "rg-example"
  location               = "West Europe"
  administrator_login    = "psqladmin"
  administrator_password = "REPLACE_WITH_SECURE_PASSWORD"
}
```
## Contributing

_Contributions are welcomed and must follow [Code of Conduct](https://github.com/wanted-cloud/.github?tab=coc-ov-file) and common [Contributions guidelines](https://github.com/wanted-cloud/.github/blob/main/docs/CONTRIBUTING.md)._

> If you'd like to report security issue please follow [security guidelines](https://github.com/wanted-cloud/.github?tab=security-ov-file).
---
<sup><sub>_2025 &copy; All rights reserved - WANTED.solutions s.r.o._</sub></sup>
<!-- END_TF_DOCS -->