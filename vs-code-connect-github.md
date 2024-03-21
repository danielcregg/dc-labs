
5. 
   sudo code tunnel
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
   sudo sh -c "echo 'deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode
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
   dig +short myip.opendns.com @resolver1.opendns.com
   ```

9. **Access Your Website**  
   Put the IP into a web browser page and check out your simple PHP website.

10. **Download the Shopping Cart Code**
   ```bash
   git clone --depth=1 https://github.com/danielcregg/shoppingcart/ /var/www/html/shoppingcart
   ```

11. **Rename the Shopping Cart Homepage**
   ```bash
   sudo mv /var/www/html/shoppingcart/index.html /var/www/html/shoppingcart/shop.html
   ```

11. **Move Shopping Cart Files**
    ```bash
    sudo mv /var/www/html/shoppingcart/* /var/www/html/
    ```

12. **Remove Redundant Files and Folders**
    ```bash
    sudo rm -rf /var/www/html/shoppingcart/ /var/www/html/readme.md
    ```

13. **Configure PHP File**  
    If you downloaded my simple webste above, I have a line of code to navigate to the shopping cart.
    Open the `index.php` file and uncomment line 12. Save your changes.

14. **Refresh Your Webpage**
    Open your web browser tab that contains your webpage and refresh the page.

15. **Explore the Shop**
    Click on the link that says "Go to Shop".
