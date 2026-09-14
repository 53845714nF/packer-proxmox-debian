# Debian Packer Builder für Proxmox

Dieses Projekt stellt Packer-Dateien bereit, um ein Basis-Image von Debian 13 für die Verwendung auf einem Proxmox-System zu erstellen.
Verwenden Sie es wie es ist oder als Ausgangspunkt für ein stärker angepasstes Image.
Dieses Projekt installiert das Basissystem und schließt `salt-minion` ein.
Wenn Sie `salt-minion` nicht verwenden möchten, können Sie das Paket `salt-minion` aus der `cloud-init`-Datei entfernen.
Ändern Sie das `root`-Passwort in der `cloud-init`, der Standardpasswortwert ist `packer`.
Beachten Sie, dass Sie die `cloud-init`-Daten auch über Terraform festlegen können, wenn Sie eine neue VM aus der Vorlage erstellen.

Dies wurde auf Proxmox 9.1.9 getestet.

## Erste Schritte

Um dies zu verwenden, benötigen Sie:

* ISO-Dateien für das Betriebssystem, für das Sie ein Image erstellen möchten, hochgeladen auf Proxmox:
  * [Debian ISO](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/)
* Ein funktionierendes [Proxmox](https://www.proxmox.com/en/)-System
* [Packer](https://packer.io). Dieses Projekt wurde mit Packer Version 1.14.4 getestet

**Die Betriebssystem-ISO-Datei muss auf Ihr Proxmox-System hochgeladen werden.**

Der einfachste Weg, um die ISO-Datei auf Ihrem Proxmox-System zu erhalten, ist die Verwendung der Option "Download from URL" auf dem Laufwerk/dem Speicherort, den Sie für ISO-Dateien konfiguriert haben.

## Ein Image erstellen

Erstellen Sie eine `variables.pkrvars.hcl`-Datei und aktualisieren Sie die Variablen. Für eine vollständige Liste der Variablen können Sie die Datei `example_variables.pkrvars.hcl` einsehen.

> [!IMPORTANT]  
> Deaktivieren Sie die Firewall auf Ihrem System, damit Packer einen Port öffnen kann.

### Verwendung des Makefiles

Sie können die folgenden Vorlagen durch Ausführen von `make` erstellen.

## Variablen in dieser Vorlage

* `proxmox_url` - Eine Zeichenfolge in diesem Format: `https://0.0.0.0:8006/api2/json`
* `username` - Eine Zeichenfolge in diesem Format: `packer@pve!packer`
* `token` - Ihr geheimer Token als Zeichenfolge
* `node` - Name Ihres Knotens als Zeichenfolge
* `proxmox_storage_pool` - Name des Pools als Zeichenfolge
* `vm_id` - Die ID der VM als Zeichenfolge

> [!NOTE]  
> Wenn Sie einen Proxmox-API-Token erstellen, setzen Sie "Privilege Separation" auf Nein.

## Nach dem Erstellen des Images

Sobald das Image erstellt wurde, möchten Sie möglicherweise noch einige Einstellungen in der Vorlage anpassen, einschließlich der Erstellung einer cloud-init-Laufwerk.
Ein cloud-init-Laufwerk _muss_ erstellt werden, damit Sie sich per SSH in jede neu erstellte VM einloggen können. Weitere Informationen finden Sie unter [https://blog.dustinrue.com/proxmox-cloud-init/](https://blog.dustinrue.com/proxmox-cloud-init/).

## Danksagung

Vielen Dank an Dustin Rue, der Ähnliches für [CentOS/Rocky/Ubuntu](https://github.com/dustinrue/proxmox-packer) gebaut hat.
