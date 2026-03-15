/*
 * This file is used to define the versions of the providers that are used in the module.
 */

terraform {
  required_version = ">= 1.11"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.20.0"
    }
  }
}
