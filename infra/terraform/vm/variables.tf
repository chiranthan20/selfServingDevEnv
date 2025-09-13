variable "vm_resource_group" {
  type        = string
  description = "Resource group for the VMs"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vnet_iprange" {
  type        = string
}

variable "vnet_name" {
  type        = string
}

variable "vm_storage_account_name" {
  type        = string
}

variable "vm_keyvault_sku" {
  type        = string
}

variable "keyvault_name" {
  type        = string
}

variable "private_key_name" {
  type        = string
}

variable "compute_gallery_name" {
  type        = string
}

variable "computegallery_rg_name" {
  type        = string
}

variable "nsg_name" {
  type        = string
}

variable "releases" {
  description = "VM releases list"
  type = list(object({
    name     = string
    imagedef = string
    cidr     = string
    disksize = string
    os       = string
    vm_sku   = string
  }))
}

variable "jump_host_ip" {
  description = "Private/Public IP of the jump host allowed to access VMs"
  type        = string
}
