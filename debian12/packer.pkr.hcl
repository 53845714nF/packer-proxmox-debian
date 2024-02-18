# Variabels to keep Proxmox Host/Tokens secret
variable "proxmox_url" {
    type = string
}

variable "node" {
    type = string
}

variable "username" {
    type = string
}

variable "token" {
    type = string
    sensitive = true
}

variable "proxmox_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "proxmox_iso_pool" {
  type    = string
  default = "local:iso"
}

variable "debian_image" {
  type    = string
  default = "debian-12.5.0-amd64-DVD-1.iso"
}

variable "vm_id" {
  type    = string
  default = ""
}

source "proxmox-iso" "debian12" {
    # Proxmox Settings
    proxmox_url = "${var.proxmox_url}"
    node = "${var.node}"
    username = "${var.username}"
    token = "${var.token}" 
    insecure_skip_tls_verify = true

    # VM General Settings
    vm_id = "${var.vm_id}"
    vm_name = "debian12-template"
    template_description = "Debian 12 Server Image"
    
    iso_file = "${var.proxmox_iso_pool}/${var.debian_image}"
    unmount_iso = true
    
    qemu_agent = true
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "16G"
        storage_pool = "${var.proxmox_storage_pool}"
        storage_pool_type = "lvm"
        type = "virtio"
    }

    cores = "4"
    memory = "2048" 

    network_adapters {
        bridge = "vmbr0"
        model  = "virtio"
        firewall = false
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "${var.proxmox_storage_pool}"

    # PACKER Boot Commands
    boot_command = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"]
    boot = "c"
    boot_wait = "10s"

    # PACKER Autoinstall Settings
    http_directory = "debian12/http" 

    ssh_username = "root"
    ssh_password = "packer"
    ssh_timeout = "20m"
}

build {
    sources = ["source.proxmox-iso.debian12"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "rm /etc/ssh/ssh_host_*",
            "truncate -s 0 /etc/machine-id",
            "apt -y autoremove --purge 2> /dev/null",
            "apt -y clean 2> /dev/null",
            "apt -y autoclean 2> /dev/null",
            "cloud-init clean",
            "rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "debian12/files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # Unit File for Salt Minion
    provisioner "file" {
        source = "debian12/files/minion_id.service"
        destination = "/etc/systemd/system/minion_id.service"
    }

    # Install Salt Minion
    provisioner "shell" {
        inline = [
            "systemctl enable minion_id",
            "sudo curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/debian/11/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg",
            "echo 'deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/debian/11/amd64/latest bullseye main' | sudo tee /etc/apt/sources.list.d/salt.list",
            "sed -i 's/deb cdrom/#deb cdrom/' /etc/apt/sources.list",
            "sudo apt -y update",
            "sudo apt -y install salt-minion"
        ]
    }
}