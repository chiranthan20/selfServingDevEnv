resource "azurerm_resource_group" "rg" {
  name     = var.vm_resource_group
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_iprange]
  location            = var.location
  resource_group_name = var.vm_resource_group
}

resource "azurerm_subnet" "vm_subnet" {
  for_each             = { for rel in var.releases : rel.name => rel }
  name                 = "${each.key}-subnet"
  resource_group_name  = var.vm_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.cidr]
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.vm_resource_group
}

# Allow SSH/RDP only from jump host IP
resource "azurerm_network_security_rule" "allow_jump" {
  for_each = { for rel in var.releases : rel.name => rel }

  name                        = "${each.key}-allow-jump"
  priority                    = 100 + index(var.releases, each.value)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.os == "linux" ? "22" : "3389"
  source_address_prefix       = var.jump_host_ip
  destination_address_prefix  = "*"
  resource_group_name         = var.vm_resource_group
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

# Deny all other inbound
resource "azurerm_network_security_rule" "deny_all" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.vm_resource_group
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

# Associate NSG to each subnet
resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each = azurerm_subnet.vm_subnet
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

resource "azurerm_public_ip" "vm_pip" {
  for_each            = { for rel in var.releases : rel.name => rel }
  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.vm_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm_nic" {
  for_each            = { for rel in var.releases : rel.name => rel }
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.vm_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each = { for rel in var.releases : rel.name => rel if rel.os == "linux" }

  name                = each.key
  resource_group_name = var.vm_resource_group
  location            = var.location
  size                = each.value.vm_sku
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = tonumber(each.value.disksize)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  for_each = { for rel in var.releases : rel.name => rel if rel.os == "windows" }

  name                = each.key
  resource_group_name = var.vm_resource_group
  location            = var.location
  size                = each.value.vm_sku
  admin_username      = "azureuser"
  admin_password      = "ChangeM3Now!" # Replace with KeyVault or tfvars

  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = tonumber(each.value.disksize)
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
