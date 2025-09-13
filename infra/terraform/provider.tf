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
  subscription_id = "d1d6768f-8830-4d25-8594-a68b8df0529d"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}