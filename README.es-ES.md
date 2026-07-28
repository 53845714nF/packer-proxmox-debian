# Debian Packer Builder para Proxmox

Este proyecto proporciona archivos de Packer para construir una imagen básica de Debian 13 para su uso en un sistema Proxmox.
Úselo tal cual o como punto de partida para una imagen más personalizada. 
Este proyecto instala el sistema base e incluye `salt-minion`.
Si no desea utilizar `salt-minion`, puede eliminar el paquete `salt-minion` del archivo `cloud-init`.
Modifique la contraseña de `root` en el `cloud-init`, el valor de la contraseña por defecto es `packer`.
Tenga en cuenta que también puede configurar los datos de `cloud-init` a través de Terraform al crear una nueva VM a partir de la plantilla.

Esto ha sido probado en Proxmox 9.1.9

## Primeros pasos

Para utilizar esto necesitará:

* Archivos ISO del SO para el cual desea construir una imagen cargados en Proxmox:
  * [Debian ISO](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/)
* Un sistema [Proxmox](https://www.proxmox.com/en/) funcionando
* [Packer](https://packer.io). Este proyecto ha sido probado con la versión de Packer 1.14.4

**El archivo ISO del SO deberá ser cargado en su sistema Proxmox.**

La forma más sencilla de obtener el archivo ISO en su sistema Proxmox es utilizar la opción "Download from URL" en el disco/recurso compartido que configuró para los archivos ISO.

## Construcción de una Imagen

Cree un archivo `variables.pkrvars.hcl` y actualice las variables. Para ver el conjunto completo de variables, puede consultar el archivo `example_variables.pkrvars.hcl`.

> [!IMPORTANT]  
> Desactive el firewall de su sistema para que Packer pueda abrir un puerto.

### Uso del Makefile

Puede construir las siguientes plantillas ejecutando `make`.

## Variables en esta Plantilla

* `proxmox_url` - Una cadena en este formato: `https://0.0.0.0:8006/api2/json`
* `username` - Una cadena en este formato: `packer@pve!packer`
* `token` - Su token secreto como cadena
* `node` - Nombre de su nodo como cadena
* `proxmox_storage_pool` - Nombre del Pool como cadena
* `vm_id` - El Id de la VM como cadena

> [!NOTE]  
> Al crear un Token de API de Proxmox, establezca "Privilege Separation" en No.

## Después de construir la imagen

Una vez construida la imagen, querrá ajustar cualquier configuración restante en la plantilla, incluyendo la creación de una unidad cloud-init.
_Debe_ crearse una unidad cloud-init para que pueda acceder por SSH a cualquier nueva VM que cree. Para más detalles sobre cómo hacerlo, visite [https://blog.dustinrue.com/proxmox-cloud-init/](https://blog.dustinrue.com/proxmox-cloud-init/).

## Agradecimientos

Gracias a Dustin Rue quien construyó algo similar para [CentOS/Rocky/Ubuntu](https://github.com/dustinrue/proxmox-packer).
