# DC Labs

![Shell](https://img.shields.io/badge/Shell-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/danielcregg/dc-labs?style=flat-square)

A collection of hands-on lab guides and automation scripts for setting up web infrastructure on cloud virtual machines. These labs walk students through installing and configuring a LAMP stack (Linux, Apache, MySQL/MariaDB, PHP), deploying WordPress, transferring files via SFTP, setting up VS Code tunnels for remote development, and integrating a shopping cart into a PHP website.

## Contents

| File | Description |
|------|-------------|
| `website-labs/lamp.md` | Step-by-step guide to installing a full LAMP stack on Ubuntu |
| `website-labs/wordpress.md` | Guide to installing WordPress on Amazon Linux 2023 with architecture diagrams |
| `website-labs/check-lamp.sh` | Shell script that verifies all LAMP components are installed and reports their versions |
| `website-labs/update-lamp-stack.sh` | Shell script that detects and upgrades PHP and MariaDB to the latest available versions |
| `website-labs/sftp.md` | Guide to setting up SFTP file transfer using WinSCP |
| `website-labs/vs-code-tunnel-install.md` | Instructions for installing VS Code and creating tunnels for remote development |
| `website-labs/shopping-cart-lab.md` | Guide to adding a shopping cart feature to an existing PHP website |
| `rest.md` | Guide to using the WordPress REST API with Postman for CRUD operations |

## Prerequisites

- An AWS or cloud VM instance (Amazon Linux 2023 or Ubuntu)
- SSH access to the VM
- Basic familiarity with Linux terminal commands

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/danielcregg/dc-labs.git
   ```
2. Follow the labs in order, starting with `website-labs/lamp.md` to set up your LAMP stack.
3. Use the verification script to confirm your setup:
   ```bash
   curl -sL https://raw.githubusercontent.com/danielcregg/dc-labs/main/website-labs/check-lamp.sh | bash
   ```

## Usage

### Verify LAMP Stack Installation

```bash
bash website-labs/check-lamp.sh
```

### Upgrade PHP and MariaDB to Latest Versions

```bash
bash website-labs/update-lamp-stack.sh
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
