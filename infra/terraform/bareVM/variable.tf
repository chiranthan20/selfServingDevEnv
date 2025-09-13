variable "vm_resource_group" {
  type        = string
  description = "Resource group name for VM"
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

variable "nsg_name" {
  type        = string
}

variable "vm_sku" {
  type        = string
  description = "VM size (e.g., Standard_B2ms)"
}

variable "jump_host_ip" {
  type        = string
  description = "Public IP of jump host allowed for RDP"
}

variable "user_object_id" {
  description = "Object ID of the Azure AD user who triggered the pipeline"
  type        = string
}