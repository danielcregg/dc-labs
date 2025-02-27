# Setting Up SFTP for File Transfer

<img src="https://github.com/danielcregg/dc-labs/assets/22198586/09887dea-e316-45c1-affb-91f50c8f9f40" alt="SFTP Transfer" width="300" align="right"/>

> **Secure File Transfer Protocol (SFTP)** enables you to seamlessly work on files locally and transfer them to your remote AWS VM.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Step-by-Step Guide](#step-by-step-guide)
  - [1. SSH into your VM](#1-ssh-into-your-vm)
  - [2. Configure Root Login](#2-configure-root-login)
  - [3. Set Root Password](#3-set-root-password)
  - [4. Identify Your IP Address](#4-identify-your-ip-address)
  - [5. Install WinSCP](#5-install-winscp)
  - [6. Connect with WinSCP](#6-connect-with-winscp)
  - [7. Accept Security Warning](#7-accept-security-warning)
  - [8. Transfer Files](#8-transfer-files)
- [Troubleshooting](#troubleshooting)

## Prerequisites

- AWS account with running VM instance
- Administrator access to your local machine
- Basic understanding of terminal commands

## Step-by-Step Guide

### 1. SSH into your VM

<details>
<summary>Open the AWS console and CloudShell</summary>

1. Sign in to your AWS console
2. Open CloudShell from the navigation bar
3. Run the following command:

```bash
ssh vm
```
</details>

### 2. Configure Root Login

> ⚠️ **Security Note**: Enabling root login is generally not recommended in production environments. This is for educational purposes only.

Run the following commands to enable root login:

```bash
sudo sed -i '/PermitRootLogin/c\PermitRootLogin yes' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

These commands:
1. Update the SSH configuration to permit root login
2. Restart the SSH service to apply changes

### 3. Set Root Password

Set the root password to `tester` with this command:

```bash
sudo echo -e 'te$tervm1\nte$tervm1' | sudo passwd root
```

### 4. Identify Your IP Address

Retrieve your public IP address:

```bash
curl -s ifconfig.me
```

**Important:** Make a note of this IP address as you'll need it in the next steps.

### 5. Install WinSCP

<kbd>[<img src="https://winscp.net/favicon.ico" width="16" height="16"/> Click here to download WinSCP](https://atlantictu-my.sharepoint.com/:u:/g/personal/daniel_cregg_atu_ie/Ef3-CXVnbR78LjDgJAQTtlgBeWnwi4EuWv8JAeo18iLGKQ?e=gUOtB7&download=1)</kbd>

### 6. Connect with WinSCP

1. Launch WinSCP
2. Enter your connection details:
   
   | Field | Value |
   |-------|-------|
   | Host name | *Your VM IP address* |
   | User name | **root** |
   | Password | **te$tervm1** |

3. Click **Login**

![WinSCP Login Screen](https://github.com/danielcregg/dc-labs/assets/22198586/3ba3fc86-e3fa-4ab0-b385-e1d317be86b4)

### 7. Accept Security Warning

If prompted with a security warning, click **Yes** to continue:

![Security Warning](https://github.com/danielcregg/dc-labs/assets/22198586/238d66b6-8354-446e-8417-1df886d05b91)

### 8. Transfer Files

After successful login, you'll see:
- Left pane: Your local Windows files
- Right pane: Your remote Linux VM files

Drag and drop files between the panes to transfer them.

## Troubleshooting

<details>
<summary>Connection issues?</summary>

If you cannot connect to your VM:
1. Verify that port 22 is open in your AWS security group settings
2. Check that your VM is running
3. Ensure you're using the correct IP address
4. Verify that your root login and password are set correctly
</details>

<details>
<summary>File transfer problems?</summary>

1. Check file permissions on your VM
2. Ensure you have sufficient disk space
3. Try reconnecting to the server
</details>

---

*This guide was prepared for educational purposes as part of AWS cloud services training.*
