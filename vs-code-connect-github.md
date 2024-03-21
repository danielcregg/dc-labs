# **How to install VS Code tunnels**

**Prerequisites:**

* A Virtual Machine (VM) running a LAMP stack.
* Basic understanding of command-line interfaces.

**Procedure**

1. **SSH into your VM**  
   In our cloud shell you can ssh into your vm using the following command.
   ```bash
   ssh vm
   ```

2. **Install the Microsoft apt repository for downloading VS Code. Run the next 5 lines altogether.**
   ```bash
   sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg &&
   sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ &&
   sudo sh -c "echo 'deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode &&
   stable main' > /etc/apt/sources.list.d/vscode.list" &&
   sudo apt update -qq -y
   ```

3. **Install VS Code**
   ```bash
   sudo apt install code -qq -y
   ```
4. **Install the VS Code Tunnel extension**
   ```bash
   sudo code --install-extension ms-vscode.remote-server
   ```
5. **Create a VS Code tunnel using the following command and follow the instructions in your terminal to connect to VS Code.**
   ```bash
   cd /var/www/html/;sudo code tunnel --accept-server-license-terms
   ```  
