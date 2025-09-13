terraform {

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.42.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

    external = {
      source  = "hashicorp/external"
      version = "2.3.1"
    }

  }
  required_version = ">=1.3.7"
}