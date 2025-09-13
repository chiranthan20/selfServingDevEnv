variable "product_name" {
  type = string
}

variable "os_type" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "vnet_resource_group" {
  type = string
}

variable "gallery_resource_group" {
  type = string
}

variable "gallery_name" {
  type = string
}

variable "replication_regions" {
  type = list(string)
}

variable "storage_account_type" {
  type = string
}

variable "subscription" {
  type = string
}

variable "gallery_image_version" {
  type = string
}

variable "images" {
  type = map(object({
    image_publisher       = string
    image_offer           = string
    image_sku             = string
    image_version         = string
    release_version       = string
    image_name_in_gallery = string
  }))
}

source "azure-arm" "ubuntu-image" {
  private_virtual_network_with_public_ip = true
  virtual_network_name                   = var.vnet_name
  virtual_network_subnet_name            = var.subnet_name
  virtual_network_resource_group_name    = var.vnet_resource_group

  os_type                   = "${var.os_type}"
  build_resource_group_name = "${var.vnet_resource_group}"
  vm_size                   = "${var.vm_size}"
  temp_os_disk_name         = substr(uuidv4(), 24, 36)
  use_azure_cli_auth        = true
}

build {
  dynamic "source" {
    for_each = var.images
    labels   = ["azure-arm.ubuntu-image"]
    content {
      name            = source.key
      image_publisher = source.value.image_publisher
      image_offer     = source.value.image_offer
      image_sku       = source.value.image_sku
      image_version   = source.value.image_version

      # Push the Image to the Shared Image Gallery
      shared_image_gallery_destination {
        subscription         = "${var.subscription}"
        resource_group       = "${var.gallery_resource_group}"
        gallery_name         = "${var.gallery_name}"
        image_name           = "${source.value.image_name_in_gallery}"
        image_version        = "${var.gallery_image_version}"
        replication_regions  = "${var.replication_regions}"
        storage_account_type = "${var.storage_account_type}"
      }
    }
  }

  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt install software-properties-common -y",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y"
    ]
  }

  provisioner "file" {
    source      = "../playbooks/${lower(var.product_name)}/roles"
    destination = "/tmp/roles"
  }

  
  provisioner "shell" {
    inline = [
      "sudo cp -r /tmp/roles/* /etc/ansible/roles"
    ]
  }

  provisioner "ansible-local" {
    playbook_file   = "../playbooks/ubuntu-playbook.yml"
    playbook_dir    = "../playbooks"
    role_paths      = ["../../playbooks/${lower(var.product_name)}/roles"]
    extra_arguments = ["--extra-vars", "image_name=${source.name}"]
  }

  post-processor "shell-local" {
    inline = [
      "sudo apt remove ansible -y"
    ]
  }
}