# **How to add the Shopping Cart to your Website**

**Prerequisites:**

* A Virtual Machine running a LAMP stack hosting an index.php website.
* Basic understanding of command-line interfaces.

**Procedure**

1. **SSH into your VM**  
   In our cloud shell you can ssh into your vm using the following command.
   ```bash
   ssh vm
   ```

2. **Create a VS Code Tunnel**
   ```bash
   sudo code tunnel
   ```

3. **Open VS Code in Your Browser**  
   Click on the URL link in the bash terminal to open your browser window to VS Code.

4. **Navigate to Your Web Directory**  
   Open /var/www/html in VSCode. A quick way to do this is the following.
   Replace `home/azureuser` in the URL with `var/www/html` and press enter. Allow the page to reload.

5. **Download a Simple PHP Website**  
   If you do not already have a website you can run this command to download a simple website.
   ```bash
   sudo wget https://raw.githubusercontent.com/danielcregg/simple-php-website/main/index.php -P /var/www/html/
   ```

6. **Find Your VM's IP Address**
   ```bash
   dig +short myip.opendns.com @resolver1.opendns.com
   ```

7. **Access Your Website**  
   Put the IP into a web browser page and check out your simple PHP website.

8. **Download the Shopping Cart Code**
   ```bash
   git clone --depth=1 https://github.com/danielcregg/shoppingcart/ /var/www/html/shoppingcart
   ```

9. **Rename the Shopping Cart Homepage**
   ```bash
   sudo mv /var/www/html/shoppingcart/index.html /var/www/html/shoppingcart/shop.html
   ```

10. **Move Shopping Cart Files**
    ```bash
    sudo mv /var/www/html/shoppingcart/* /var/www/html/
    ```

11. **Remove Redundant Files and Folders**
    ```bash
    sudo rm -rf /var/www/html/shoppingcart/ /var/www/html/readme.md
    ```

12. **Configure PHP File**  
    If you downloaded my simple webste above, I have a line of code to navigate to the shopping cart.
    Open the `index.php` file and uncomment line 12. Save your changes.

13. **Refresh Your Webpage**
    Open your web browser tab that contains your webpage and refresh the page.

14. **Explore the Shop**
    Click on the link that says "Go to Shop".
