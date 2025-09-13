vm_resource_group = "abcproduct-rg"
location            = "West Europe"
# VNET variables
vnet_iprange = "192.168.0.0/16"
vnet_name    = "abcproduct-infra-vnet"
vm_sku       = "Standard_B2ms"
# Storage account
vm_storage_account_name = "abcprodwinstorage"

# Keyvault to store private key
vm_keyvault_sku = "standard"
keyvault_name     = "abcproduct-keyvault"


# SSH Keys
private_key_name     = "vmprivatekey"
vmss_public_key_name = "abcproduct_vm_publickey"

# Compute Gallery
compute_gallery_name   = "abcproductcomputegallery1"
computegallery_rg_name = "abcproductosimage"

# NSG Name
nsg_name = "abcproduct_vm_nsg"

# LoadBlancer
loadbalancer_public_ip_name = "abcproduct_loadbalancer_public_ip"
loadbalancer_name           = "abcproduct_vm_loadbalancer"
loadbalancer_sku            = "Standard"
loadbalancer_public_ip_sku  = "Standard"

jump_host_ip = <public_IP>

releases = [
  { name : "va40", imagedef : "abc-VA10-Linux", cidr : "192.168.1.0/24", disksize : "50", os : "linux", vm_sku : "Standard_B4ms" }
]
