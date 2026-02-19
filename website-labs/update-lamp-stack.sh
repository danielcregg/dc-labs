#!/bin/bash

# ============================================================
# update-lamp-stack.sh
# Upgrades PHP and MariaDB on Amazon Linux 2023 to meet
# WordPress recommended versions:
#   - PHP 8.3+
#   - MariaDB 10.11+
# ============================================================

set -e

# --- Target versions ---
TARGET_PHP="8.3"
TARGET_MARIADB="10.11"

# --- Colours ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No colour

# --- Helper: compare two version strings (returns 0 if $1 >= $2) ---
version_gte() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# --- Capture current versions ---
PHP_VER=$(php -v 2>/dev/null | head -n1 | awk '{print $2}' | cut -d'-' -f1)
MYSQL_VER=$(mysql --version 2>/dev/null | awk '{print $3}' | tr -d ',')
# Strip "-MariaDB" suffix if present
MARIADB_VER=$(echo "$MYSQL_VER" | sed 's/-MariaDB//')

echo ""
echo "  ╔═════════════════════════════════════════════╗"
echo "  ║        LAMP STACK  UPGRADE  CHECK           ║"
echo "  ╠═════════════════════════════════════════════╣"
echo "  ║                                             ║"
printf "  ║   PHP      : current %-10s target %s  ║\n" "$PHP_VER" "$TARGET_PHP+"
printf "  ║   MariaDB  : current %-10s target %s║\n" "$MARIADB_VER" "$TARGET_MARIADB+"
echo "  ║                                             ║"
echo "  ╚═════════════════════════════════════════════╝"
echo ""

# --- Track what needs upgrading ---
UPGRADE_PHP=false
UPGRADE_MARIADB=false

if [ -z "$PHP_VER" ]; then
  echo -e "${RED}[!!] PHP is not installed. Please install the LAMP stack first.${NC}"
  exit 1
fi

if [ -z "$MARIADB_VER" ]; then
  echo -e "${RED}[!!] MariaDB is not installed. Please install the LAMP stack first.${NC}"
  exit 1
fi

if version_gte "$PHP_VER" "$TARGET_PHP"; then
  echo -e "${GREEN}[OK] PHP $PHP_VER already meets the requirement (>= $TARGET_PHP)${NC}"
else
  echo -e "${YELLOW}[>>] PHP $PHP_VER will be upgraded to $TARGET_PHP${NC}"
  UPGRADE_PHP=true
fi

if version_gte "$MARIADB_VER" "$TARGET_MARIADB"; then
  echo -e "${GREEN}[OK] MariaDB $MARIADB_VER already meets the requirement (>= $TARGET_MARIADB)${NC}"
else
  echo -e "${YELLOW}[>>] MariaDB $MARIADB_VER will be upgraded to $TARGET_MARIADB${NC}"
  UPGRADE_MARIADB=true
fi

if [ "$UPGRADE_PHP" = false ] && [ "$UPGRADE_MARIADB" = false ]; then
  echo ""
  echo -e "${GREEN}Nothing to upgrade — your LAMP stack is already up to date!${NC}"
  echo ""
  exit 0
fi

echo ""
echo "Starting upgrade..."
echo ""

# =============================================================
# Upgrade PHP
# =============================================================
if [ "$UPGRADE_PHP" = true ]; then
  echo "--- Upgrading PHP to $TARGET_PHP ---"

  # Remove old PHP packages
  echo "  Removing old PHP packages..."
  sudo dnf remove -y php php-* 2>/dev/null || true

  # Install PHP 8.3 and extensions needed for WordPress
  echo "  Installing PHP $TARGET_PHP and WordPress extensions..."
  sudo dnf install -y \
    php${TARGET_PHP} \
    php${TARGET_PHP}-mysqli \
    php${TARGET_PHP}-mysqlnd \
    php${TARGET_PHP}-gd \
    php${TARGET_PHP}-curl \
    php${TARGET_PHP}-xml \
    php${TARGET_PHP}-mbstring \
    php${TARGET_PHP}-zip \
    php${TARGET_PHP}-intl

  echo -e "  ${GREEN}[OK] PHP upgraded${NC}"
  echo ""
fi

# =============================================================
# Upgrade MariaDB
# =============================================================
if [ "$UPGRADE_MARIADB" = true ]; then
  echo "--- Upgrading MariaDB to $TARGET_MARIADB ---"

  # Stop current MariaDB service
  echo "  Stopping MariaDB..."
  sudo systemctl stop mariadb

  # Remove old MariaDB packages
  echo "  Removing old MariaDB packages..."
  sudo dnf remove -y mariadb-server mariadb105-server 2>/dev/null || true

  # Install MariaDB 10.11
  echo "  Installing MariaDB $TARGET_MARIADB..."
  sudo dnf install -y mariadb1011-server

  # Start and enable the new MariaDB
  echo "  Starting MariaDB $TARGET_MARIADB..."
  sudo systemctl start mariadb
  sudo systemctl enable mariadb

  echo -e "  ${GREEN}[OK] MariaDB upgraded${NC}"
  echo ""
fi

# =============================================================
# Restart Apache to pick up new PHP version
# =============================================================
echo "--- Restarting Apache ---"
sudo systemctl restart httpd

# =============================================================
# Verify results
# =============================================================
NEW_PHP_VER=$(php -v 2>/dev/null | head -n1 | awk '{print $2}' | cut -d'-' -f1)
NEW_MYSQL_VER=$(mysql --version 2>/dev/null | awk '{print $3}' | tr -d ',')
NEW_MARIADB_VER=$(echo "$NEW_MYSQL_VER" | sed 's/-MariaDB//')

echo ""
echo "  ╔═════════════════════════════════════════════╗"
echo "  ║        LAMP STACK  UPGRADE  COMPLETE        ║"
echo "  ╠═════════════════════════════════════════════╣"
echo "  ║                                             ║"
printf "  ║   PHP      : %-31s║\n" "$NEW_PHP_VER"
printf "  ║   MariaDB  : %-31s║\n" "$NEW_MARIADB_VER"
echo "  ║                                             ║"
echo "  ╠═════════════════════════════════════════════╣"

FINAL_PASS=true
if ! version_gte "$NEW_PHP_VER" "$TARGET_PHP"; then
  FINAL_PASS=false
fi
if ! version_gte "$NEW_MARIADB_VER" "$TARGET_MARIADB"; then
  FINAL_PASS=false
fi

if [ "$FINAL_PASS" = true ]; then
  echo "  ║                                             ║"
  echo "  ║   [OK]  All components meet requirements    ║"
  echo "  ║   [OK]  LAMP stack is ready for WordPress   ║"
  echo "  ║                                             ║"
else
  echo "  ║                                             ║"
  echo "  ║   [!!]  Some components did not upgrade     ║"
  echo "  ║   [!!]  Check the output above for errors   ║"
  echo "  ║                                             ║"
fi

echo "  ╚═════════════════════════════════════════════╝"
echo ""
