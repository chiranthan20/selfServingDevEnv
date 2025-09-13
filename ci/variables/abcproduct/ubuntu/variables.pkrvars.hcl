vm_size                = "Standard_B8ms"
vnet_name              = "projectName-vm-vnet"
subnet_name            = "imagebuilder-subnet"
vnet_resource_group    = "projectName-agentinfra"
gallery_resource_group = "projectNameosimage"
gallery_name           = "projectNamecomputegallery1"
replication_regions    = ["westeurope"]
storage_account_type   = "Standard_LRS"
os_type                = "Linux"
images = {
  "opsVA10Linux" : {
    "image_publisher" : "Canonical",
    "image_offer" : "UbuntuServer",
    "image_sku" : "18_04-lts-gen2",
    "image_version" : "18.04.202305010",
    "release_version" : "VA10",
    "image_name_in_gallery" : "ops-VA10-Linux"
  }
}
#subscription will be set via commandline
#gallery_image_version will be set via commandline
  