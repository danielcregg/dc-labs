<p align="center">
  <img src="https://github.com/danielcregg/dc-labs/assets/22198586/944ad682-f532-4132-b013-e8a7d03c6b4b">
</p>

LAMP stack is a popular open-source web platform commonly used to run dynamic websites. It includes **L**inux, **A**pache, **M**ySQL, and **P**HP and is considered by many the platform of choice for development and deployment of high-performance web applications which require a solid and reliable foundation. Here is a very informative video on the topic https://www.youtube.com/watch?v=WY8jwTNYTfg. 

**Linux** is an operating system that controls the hardware and runs the software. 

**Apache** is a popular web server software. A Web server is a program that uses HTTP (Hypertext Transfer Protocol) to serve the files that form Web pages to users, in response to their requests, which are forwarded by their computers' HTTP clients. 

**MySQL** is a database management system.  

**PHP** is a server-side scripting language designed for web development. PHP code is interpreted by a web server via a PHP processor module, which generates the resulting web page.   

<p align="center">
    <img src="https://upload.wikimedia.org/wikipedia/commons/f/fa/LAMPP_Architecture.png">
</p>  

# STEP ONE - INSTALL APACHE

The Apache web server is currently the most popular web server in the world, which makes it a great default choice for hosting a website. We can install Apache easily using Ubuntu's package manager, apt. A package manager allows us to install most software pain-free from a repository maintained by Ubuntu. You can learn more about how to use apt here.  

We will get started by executing the below terminal command which will update our packages database and then upgrade all our packages to the latest versions.  

```bash
sudo apt update 
```

Next, we will install apache2, our web server program, using the following terminal command: 

```bash
sudo apt -y install apache2 
```

We can test that apache2 has installed correctly by trying to connect to our virtual machine using a browser. To do this we will need your virtual machines public IP address. You can find your public IP using the follow command: 

```bash
dig +short myip.opendns.com @resolver1.opendns.com 
```

Enter the IP you got from the above command into a browser like below:  

![image](https://github.com/danielcregg/dc-labs/assets/22198586/94017af5-0a2f-4e09-a420-ac635303a2a6)


When we enter the IP address of our web server into our browser it will send a http request to our web server. Our web server will respond by sending back the default html web page, index.html. This webpage, index.html, can be found on our web server in /var/www/html/index.html. You will see the Default Ubuntu Apache web page, which is there for informational and testing purposes. It should look something like this:  

![image](https://github.com/danielcregg/dc-labs/assets/22198586/b5b46b41-9d24-41e7-8017-081687a3b31e)  

If you see this page, then your web server is now correctly installed. If not, please restart the lab.  

# STEP TWO — INSTALL MYSQL  

Now that we have our web server up and running, it is time to install MySQL. MySQL is a database management system. It will organise and provide access to databases where our site can store information.  

Run the following command to install MySQL:  

```bash
sudo apt -y install mysql-server 
```
To test that mySQL is installed correctly let us log in to mySQL using the following command:  

```bash
sudo mysql 
```
You should see output like the following. Notice the command prompt has change to mysql>. You can now enter mySQL commands.  

![image](https://github.com/danielcregg/dc-labs/assets/22198586/a93492a1-2f51-436d-8e7a-024bf5f29952)  

To return back to our normal bash command prompt enter the following mySQL command: 

exit 

You should have output like below:  

![image](https://github.com/danielcregg/dc-labs/assets/22198586/8a0241f7-d050-4b9d-93eb-e1de4feeed53)

# STEP THREE — INSTALL PHP  

PHP is the component of our setup that will process code to display dynamic content. It can run scripts, connect to our MySQL databases to get information, and hand the processed content over to our web server to display.  

We can once again leverage the apt system to install our components. We're going to include some helper packages as well:  

```bash
sudo apt -y install php 
```

In order to test that our system is configured properly for PHP, we will create a basic PHP webpage file that contains some php code to display all php information. We will call this file info.php. For Apache to find the file and serve it correctly, it must be saved to a specific directory, which is called the "web root". This directory is located at /var/www/html/. We can create the file info.php at that location by running the following terminal command:  

```bash
sudo touch /var/www/html/info.php 
```

Run the following command to update the file permissions so that we can write to the file: 

```bash
sudo chmod 666 /var/www/html/info.php 
```

We want to put the following php code inside the file:  

\<?php  
&nbsp;&nbsp;&nbsp;&nbsp;phpinfo();  
?>  

 

To insert this code into the file run the following command: 

  

sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php 

 

Now go to your browser and enter your public  IP/info.php (e.g. 53.24.55.9/info.php) address again. The webpage that comes back should look something like this:  

![image](https://github.com/danielcregg/dc-labs/assets/22198586/da971cb9-aa35-49d6-af20-b82561fed086)  

This page gives you information about your server from the perspective of PHP. It is useful for debugging and to ensure that your settings are being applied correctly. If this was successful, then your PHP is working as expected. 

We want to modify the way that Apache serves webpage files when a directory is requested. Currently, if a user requests a webpage from the server, Apache will first look for a file called index.html as demonstrated previously. We want to tell our web server to prefer PHP files and server them first. We will make Apache look for the index.php file first.  

To do this we need to edit the file dir.conf in /etc/apache2/mods-enabled/ 

The dir.conf currently looks like this:  

<IfModule mod_dir.c>  

    DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm 

</IfModule>  

We want to move the PHP index file highlighted above (in blue) to the first position after the DirectoryIndex specification, like this:  

 

<IfModule mod_dir.c>  

    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm </IfModule> 

To do this you can run the following terminal command:  

sudo sed -i.bak -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-enabled/dir.conf; if [ $? -eq 0 ]; then echo "SUCCESS!"; else echo "FAILURE! - Please try again."; fi 

After this, we need to restart the Apache web server in order for our changes to be recognized. You can do this by typing this:  

sudo service apache2 restart 

 

Finally, let’s update our default index.php webpage. 

Navigate to the folder containing the default index.html file and see if it exists:  

![image](https://github.com/danielcregg/dc-labs/assets/22198586/6100a3ee-0a93-428e-99d2-c32223d0118c)

cd /var/www/html/ 

Create an index.php file 

sudo touch /var/www/html/index.php 

Use the vi editor to open the new index.html file.  

sudo nano /var/www/html/index.php 

 

Enter the following html code, then save and close the file (Ctrl + O and Ctrl + X). 

 

<!DOCTYPE html> 

<html> 

        <body> 

 

                <h1>My Heading</h1> 

                <p>My paragraph.</p> 

 

        </body> 

</html> 

 

Navigate to your web server again using your browser and IP address. You should see the following webpage:  

 

 

Congratulations you have now created a LAMP server! Please post any issues you are having (or have solved) to the forum.  

Please confirm on the forum that you got everything working above. You will need this working to get your WordPress site running.  

RESOURCES 

https://protechgurus.com/setup-install-lamp-ubuntu-16-04-ec2-instance/ 

https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04 

https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html#AddRemoveRules 

https://www.taniarascia.com/create-a-simple-database-app-connecting-to-mysql-with-php/ 

https://stackoverflow.com/questions/30594962/sqlstatehy000-1045-access-denied-for-user-rootlocalhost-using-password 

 

sudo apt update updates the list of available packages and their versions, but it does not install or upgrade any packages. 

sudo apt- upgrade actually installs newer versions of the packages you have. After updating the lists, the package manager knows about available updates for the software you have installed. This is why you first want to update. 

sudo -i       will get you admin user. 
