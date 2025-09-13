variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "container_group_name" {
  description = "The name of the container group"
  type        = string
}

variable "os_type" {
  description = "The OS type for the container group (Linux or Windows)"
  type        = string
  default     = "Linux"
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "image" {
  description = "Docker image to deploy"
  type        = string
}

variable "cpu" {
  description = "CPU cores allocated to the container"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory (in GB) allocated to the container"
  type        = number
  default     = 1.5
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "dns_name_label" {
  description = "DNS name label for the public FQDN"
  type        = string
}
