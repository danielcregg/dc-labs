# How to Install SFTP

We want to be able to work on files on our laptop and then copy them over to our remote VM in the cloud. To enable this functionality, we use Secure File Transport Protocol (SFTP). You will need to install an SFTP client. The SFTP client we will use in this lab is `WinSCP`.

## Steps

### 1. SSH into your VM
Open the AWS console. Open CloudShell. Enter the following command: 
```bash
ssh vm
```

### 2. Enable root login on your VM
Run the following commands to enable root login. The first command updates the ssh config file to permit root user to log in. The second command restarts the ssh service to make sure it will pick up the configurate change we just make.
```bash
sudo sed -i '/PermitRootLogin/c\PermitRootLogin yes' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### 3. Set root password to *tester*
Execute the following command to set the root password. This command uses the passwd command to set the root user password to `tester`.
```bash
sudo echo -e "tester\ntester" | sudo passwd root
```

### 4. Find your public IP address
Use the following command to find your public IP address:
```bash
dig +short myip.opendns.com @resolver1.opendns.com
```

### 5. Download WinSCP
Click [HERE](https://atlantictu-my.sharepoint.com/:u:/g/personal/daniel_cregg_atu_ie/Ef3-CXVnbR78LjDgJAQTtlgBeWnwi4EuWv8JAeo18iLGKQ?e=gUOtB7&download=1) to download WinSCP to your PC so you can transfer files to your virtual machine.

### 6. Open WinSCP
1. Enter **YOUR Virtual Machine IP address** in the Host name box.
2. Enter **root** in the User name box.
3. Enter **tester** in the Password box.
4. Click **Login**.

![image](https://github.com/danielcregg/dc-labs/assets/22198586/3ba3fc86-e3fa-4ab0-b385-e1d317be86b4)

### 7. Accept the Security Warning
Click **Yes** to the following message if it pops up.

![image](https://github.com/danielcregg/dc-labs/assets/22198586/238d66b6-8354-446e-8417-1df886d05b91)

### 8. Transfer Files
You should be logged in as shown below. Your local Windows machine files are on the left and your remote Linux VM files are on the right. Drag and drop files in either direction.

![image](https://github.com/danielcregg/dc-labs/assets/22198586/09887dea-e316-45c1-affb-91f50c8f9f40)
