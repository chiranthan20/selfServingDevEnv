packer {
  required_version = ">=1.9.4"
  required_plugins {
    azure = {
      version = "v2.0.1"
      source  = "github.com/hashicorp/azure"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}