# Debian Packer Builder for Proxmox

This project provides Packer files to build a basic image of Debian for use on a Proxmox system.
Use it as is or as a starting point for a more fully customized image. 
This project installs the base system and include salt-minion.
If you dont want to use salt-minion you can remove the `salt-minion` package from the `cloud-init` file.
Modify the `root` password in the `cloud-init`, the default password value is `packer`.
Keep in mind that you can also set the `cloud-init` data via Terraform when you create a new VM from the template.

This has been tested on Proxmox 8.2.7

## Getting started

To use this you will need:

* ISO files for the OS you want to build an image for uploaded to Proxmox:
  * [Debian ISO](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/)
* A working [Proxmox](https://www.proxmox.com/en/) system
* [Packer](https://packer.io). This project is tested with Packer version 1.12.0

**The OS ISO file will need to be uploaded to your Proxmox system.**

The simplest way to get the ISO file on your Proxmox system is to use the "Download from URL" option on the disk/share that you configured for ISO files.

## Building an Image

Create a `variables.pkrvars.hcl` file and update the variables. For a full set of variables you can look at `example_variables.pkrvars.hcl` file.

### Using the Makefile

You can build the following templates by running `make`.

## Variabel in this Template

* `proxmox_url` - A string in this Format: `https://0.0.0.0:8006/api2/json`
* `username` - A string in this Format: `packer@pve!packer`
* `token` - Your secret token as string
* `node` - Name of your node as string
* `proxmox_storage_pool` - Name of the Pool as string
* `vm_id` - The Id of the VM as string

## After the image is built

Once the image is built you will want to adjust any remaining settings in the template including creating a cloud-init drive. A cloud-init drive _must_ be created for you to ssh into any new VMs you create. For details on how to do so visit [https://blog.dustinrue.com/proxmox-cloud-init/](https://blog.dustinrue.com/proxmox-cloud-init/).

## Acknowledgement

Thanks to Dustin Rue how build similar for [CentOS/Rocky/Ubuntu](https://github.com/dustinrue/proxmox-packer).
