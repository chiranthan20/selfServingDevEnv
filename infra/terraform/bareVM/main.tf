# Resource Group
resource "azurerm_resource_group" "vm_rg" {
  name     = var.vm_resource_group
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_iprange]
  location            = var.location
  resource_group_name = azurerm_resource_group.vm_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "default-subnet"
  resource_group_name  = azurerm_resource_group.vm_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_iprange
}

# NSG with RDP allowed only from Jump Host
resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  security_rule {
    name                       = "allow-rdp-from-jumphost"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.jump_host_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NIC
resource "azurerm_network_interface" "vm_nic" {
  name                = "barevm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows Bare VM
resource "azurerm_windows_virtual_machine" "barevm" {
  name                = "barevm-win"
  location            = var.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  size                = var.vm_sku
  admin_username      = "azureuser"
  admin_password      = "ChangeM3Now!" # Can be replaced with keyvault secrets
  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 50
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Install Azure AD login extension on the VM
resource "azurerm_virtual_machine_extension" "aad_login" {
  name                 = "AADLoginForWindows"
  virtual_machine_id   = azurerm_windows_virtual_machine.barevm.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADLoginForWindows"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
}

# Auto-shutdown at 6:00 PM
resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id     = azurerm_windows_virtual_machine.barevm.id
  location               = var.location
  daily_recurrence_time  = "1800"
  timezone               = "India Standard Time"

  notification_settings {
    enabled = false
  }
}

# Assign RBAC to the pipeline triggering user
resource "azurerm_role_assignment" "vm_rdp_access" {
  scope                = azurerm_windows_virtual_machine.barevm.id
  role_definition_name = "Virtual Machine Administrator Login" # or "Virtual Machine User Login"
  principal_id         = var.user_object_id
}