# Resource Group
resource "azurerm_resource_group" "aci_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Container Group
resource "azurerm_container_group" "aci" {
  name                = var.container_group_name
  location            = azurerm_resource_group.aci_rg.location
  resource_group_name = azurerm_resource_group.aci_rg.name
  os_type             = var.os_type

  container {
    name   = var.container_name
    image  = var.image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = var.container_port
      protocol = "TCP"
    }
  }

  ip_address_type = "Public"
  dns_name_label  = var.dns_name_label # becomes <dns_name_label>.<region>.azurecontainer.io
  restart_policy  = "Always"
}
