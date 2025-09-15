# Resource Group and Location
vm_resource_group = "barevm-rg"
location          = "West Europe"

# Networking
vnet_iprange = "10.1.0.0/16"
vnet_name    = "barevm-vnet"
subnet_iprange = "10.1.1.0/24"
nsg_name     = "barevm-nsg"

# VM Sku
vm_sku = "Standard_B2ms"

# Jump Host IP (need to replace)
jump_host_ip = "203.0.113.25"
