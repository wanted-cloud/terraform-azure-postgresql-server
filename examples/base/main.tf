module "postgresql_server" {
  source = "../.."

  name                   = "psql-example-westeurope-001"
  resource_group_name    = "rg-example"
  location               = "West Europe"
  administrator_login    = "psqladmin"
  administrator_password = "REPLACE_WITH_SECURE_PASSWORD"
}
