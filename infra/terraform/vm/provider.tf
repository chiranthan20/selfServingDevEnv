provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }

    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
provider "azurerm" {
  alias           = "gallery_subscription"
  subscription_id = "<subscription_ID>>"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}