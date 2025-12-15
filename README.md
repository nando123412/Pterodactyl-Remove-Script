# Pterodactyl Remove Script

A safe, interactive removal script to completely uninstall Pterodactyl Panel and Wings from a Linux server, including all common dependencies such as Nginx, PHP, Docker, databases, and Redis.

This script is intended for users who want to fully clean a server that previously ran Pterodactyl.

---

## WARNING – READ BEFORE USING

THIS SCRIPT IS DESTRUCTIVE.

Running this script will:
- Remove Pterodactyl Panel
- Remove Pterodactyl Wings
- Remove Nginx
- Remove PHP (all versions)
- Remove Docker
- Remove MySQL / MariaDB
- Remove Redis
- Delete all Pterodactyl-related files and directories
- Potentially delete all hosted game servers and databases

There is no undo.
Back up your data before running this script.

You are fully responsible for using this script.

---

## Supported Operating Systems

This script only supports:
- Ubuntu 20.04 or newer
- Ubuntu 22.04 or newer
- Debian 11 or newer
- Debian 12 or newer

Not supported:
- CentOS
- AlmaLinux
- Rocky Linux
- Arch Linux
- OpenSUSE
- Any non–Debian-based distribution

The script will refuse to run on unsupported systems.

---

## Safety Features

This script includes multiple safety checks:
- Operating system detection (Ubuntu/Debian only)
- Must be run as a non-root user
- Uses sudo for elevated commands
- Requires manual typed confirmation
- Interactive reboot prompt
- Does not use curl | bash

---

## What Gets Removed

Packages:
- pterodactyl-panel
- pterodactyl-wings
- nginx
- php*
- docker
- mysql / mariadb
- redis

Directories:
- /var/www/pterodactyl
- /etc/pterodactyl
- /var/lib/pterodactyl
- /var/log/pterodactyl
- /etc/nginx
- /etc/php
- /var/lib/docker
- /var/lib/mysql
- /var/lib/mariadb
- /srv/pterodactyl
- /srv/daemon-data

Other:
- Removes the pterodactyl user and group
- Flushes iptables firewall rules

---

## Installation and Usage
### automatically install
This will install the script and run it automatically.
```wget -O remove-pterodactyl.sh https://raw.githubusercontent.com/nando123412/Pterodactyl-Remove-Script/main/remove-pterodactyl.sh && chmod +x remove-pterodactyl.sh && ./remove-pterodactyl.sh```


### manual install
1. Download the script:
```wget https://raw.githubusercontent.com/nando123412/Pterodactyl-Remove-Script/main/remove-pterodactyl.sh```

3. Inspect the script (recommended):
```nano remove-pterodactyl.sh```

5. Make the script executable:
```chmod +x remove-pterodactyl.sh```

7. Run the script:
```./remove-pterodactyl.sh```

You will be required to type:
DELETE-PTERODACTYL
to confirm execution.

---

## Reboot

At the end of the script, you will be prompted to reboot.

Rebooting is strongly recommended to ensure:
- All services are fully stopped
- Docker is completely unloaded
- The system is clean

---

## Post-Removal Checks (Optional)

You can verify removal by running:
systemctl status wings nginx docker mysql

All services should report not found or inactive.

---

## FAQ

Can I use this on a production server?
Only if you intend to completely remove everything related to Pterodactyl and its dependencies.

Can I reinstall Pterodactyl afterward?
Yes. After reboot, the system is effectively a clean base OS.

Why not use curl | bash?
Piping remote code directly into a shell is unsafe. This project prioritizes transparency and security.

---

## License

MIT License.
Free to use, modify, and distribute.
No warranty is provided.

---

## Contributing

Pull requests are welcome for:
- Improved safety checks
- Additional OS validation
- Cleaner uninstall logic

---

## Disclaimer

This project is not affiliated with the official Pterodactyl Project.

Use at your own risk.
