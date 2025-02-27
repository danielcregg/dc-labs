# Installing WordPress on Amazon Linux 2023

<img src="https://s.w.org/style/images/about/WordPress-logotype-standard.png" alt="WordPress Logo" width="300" align="right"/>

> WordPress is the world's most popular Content Management System (CMS), powering approximately 43% of all websites on the internet.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Step-by-Step Guide](#step-by-step-guide)
  - [1. Create WordPress Database and User](#1-create-wordpress-database-and-user)
  - [2. Download WordPress](#2-download-wordpress)
  - [3. Configure Document Root and Permissions](#3-configure-document-root-and-permissions)
  - [4. Install Required PHP Extensions](#4-install-required-php-extensions)
  - [5. Complete Web Installation](#5-complete-web-installation)
- [Troubleshooting](#troubleshooting)
- [Reset Instructions](#reset-instructions)

## Prerequisites

- Amazon Linux 2023 instance running
- Basic understanding of terminal commands
- LAMP stack installed (Linux, Apache, MySQL, PHP)

## Step-by-Step Guide

### 1. Create WordPress Database and User

First, we'll create a database and user for WordPress to use. Log in to MySQL as root by issuing the following command:

```bash
sudo mysql

```

Inside the MySQL prompt, execute these commands:

```sql
# View existing databases
SHOW DATABASES;

# Create a new database for WordPress
CREATE DATABASE wordpress;

# Create a new user for WordPress
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';

# Grant the user full privileges on the WordPress database
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';

# Apply the privilege changes
FLUSH PRIVILEGES;

# Exit MySQL
exit;

```

Restart MySQL to ensure changes take effect:

```bash
sudo systemctl restart mariadb

```

### 2. Download WordPress

Next, download the latest version of WordPress:

```bash
# Download WordPress to your home directory
sudo wget -P /home/$USER/ https://wordpress.org/latest.tar.gz

```
```bash
# Extract the WordPress archive
sudo tar zxvf /home/$USER/latest.tar.gz -C /home/$USER/

```
```bash
# Clean up the downloaded archive
sudo rm /home/$USER/latest.tar.gz

```

### 3. Configure Document Root and Permissions

Copy WordPress files to the Apache document root and set appropriate permissions:

```bash
# Copy WordPress files to Apache document root
sudo cp -rf /home/$USER/wordpress/* /var/www/html/

# Set proper ownership for the web server
sudo chown -R apache:apache /var/www/html/

```

> ⚠️ **Note**: Amazon Linux 2023 uses `apache` as the web server user, not `www-data` like Ubuntu.

### 4. Install Required PHP Extensions

Install the PHP extensions that WordPress requires:

```bash
# Install required and recommended PHP extensions
sudo dnf install php-mysqli php-mysqlnd php-gd php-curl php-xml php-mbstring php-zip php-intl php-json -y

```
php-imagick
```bash
# Restart Apache to load the new extensions
sudo systemctl restart httpd

```

### 5. Complete Web Installation

<details>
<summary>Find your instance's public IP address</summary>

```bash
curl -s ifconfig.me
```
</details>

Now complete the installation through your web browser:

1. **Navigate to your server's IP address** in a web browser

2. **Select your language**
   
   ![WordPress Language Selection](https://wordpress.org/support/files/2018/10/install-step1.png)

3. **Prepare for installation**
   
   Click "Let's go!"

4. **Enter database information**
   
   | Field | Value |
   |-------|-------|
   | Database Name | `wordpress` |
   | Username | `wordpressuser` |
   | Password | `password` |
   | Database Host | `localhost` |
   | Table Prefix | `wp_` (default) |

5. **Run the installation**
   
   Click "Submit" and then "Run the installation"

6. **Set up your site**
   
   | Field | Value |
   |-------|-------|
   | Site Title | *Your choice* |
   | Username | `admin` |
   | Password | *Choose a strong password* |
   | Email | *Your email address* |

   Click "Install WordPress"

7. **Log in to your new WordPress site**
   
   Use your new admin credentials to log in

## Troubleshooting

<details>
<summary>Permission Issues</summary>

If you encounter permission errors:

```bash
# Verify and correct permissions if needed
sudo chmod -R 755 /var/www/html/
sudo chown -R apache:apache /var/www/html/
```
</details>

<details>
<summary>Database Connection Issues</summary>

If WordPress can't connect to the database:

1. Verify MySQL is running:
   ```bash
   sudo systemctl status mariadb
   ```

2. Verify database credentials:
   ```bash
   sudo mysql -u wordpressuser -p -D wordpress
   ```
   
3. Check if the user has proper permissions:
   ```bash
   sudo mysql -e "SHOW GRANTS FOR 'wordpressuser'@'localhost';"
   ```
</details>

## Reset Instructions

If you want to start over, use this command to reset everything:

```bash
sudo rm -rf ~/wordpress; \
sudo rm -f ~/latest.tar.gz; \
sudo rm -rf /var/www/html/*; \
sudo mysql -u root -e "DROP DATABASE IF EXISTS wordpress; DROP USER IF EXISTS wordpressuser@localhost; FLUSH PRIVILEGES;"; \
sudo systemctl restart httpd
```

> ⚠️ **Warning**: This command will delete all content in your home directory and web root. Use with caution!

---

*This guide was prepared for educational purposes as part of AWS cloud services training.*
