#!/bin/bash

# ============================================================
# update-lamp-stack.sh
# Upgrades PHP and MariaDB on Amazon Linux 2023 to the latest
# versions available in the dnf repositories.
# ============================================================

set -e

# --- Colours ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No colour

# --- Helper: compare two version strings (returns 0 if $1 >= $2) ---
version_gte() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# =============================================================
# Detect latest available PHP version from dnf repos
# Looks for packages named php8.X and picks the highest version
# =============================================================
detect_latest_php() {
  # Search for php8.* base packages, extract version numbers, sort and pick highest
  LATEST_PHP=$(dnf list available php8.* 2>/dev/null \
    | grep -oP '^php\K[0-9]+\.[0-9]+' \
    | sort -t. -k1,1n -k2,2n \
    | tail -n1)

  # Also check what's already installed in case it's newer
  INSTALLED_PHP=$(dnf list installed php8.* 2>/dev/null \
    | grep -oP '^php\K[0-9]+\.[0-9]+' \
    | sort -t. -k1,1n -k2,2n \
    | tail -n1)

  # Pick whichever is higher
  if [ -n "$INSTALLED_PHP" ] && [ -n "$LATEST_PHP" ]; then
    if version_gte "$INSTALLED_PHP" "$LATEST_PHP"; then
      echo "$INSTALLED_PHP"
    else
      echo "$LATEST_PHP"
    fi
  elif [ -n "$LATEST_PHP" ]; then
    echo "$LATEST_PHP"
  elif [ -n "$INSTALLED_PHP" ]; then
    echo "$INSTALLED_PHP"
  else
    echo ""
  fi
}

# =============================================================
# Detect latest available MariaDB server version from dnf repos
# Looks for packages named mariadbXXXX-server and picks highest
# =============================================================
detect_latest_mariadb() {
  # Search for mariadb*-server packages, extract version digits
  LATEST_MDB=$(dnf list available mariadb*-server 2>/dev/null \
    | grep -oP '^mariadb\K[0-9]+' \
    | sort -n \
    | tail -n1)

  INSTALLED_MDB=$(dnf list installed mariadb*-server 2>/dev/null \
    | grep -oP '^mariadb\K[0-9]+' \
    | sort -n \
    | tail -n1)

  # Pick whichever is higher
  if [ -n "$INSTALLED_MDB" ] && [ -n "$LATEST_MDB" ]; then
    if [ "$INSTALLED_MDB" -ge "$LATEST_MDB" ] 2>/dev/null; then
      echo "$INSTALLED_MDB"
    else
      echo "$LATEST_MDB"
    fi
  elif [ -n "$LATEST_MDB" ]; then
    echo "$LATEST_MDB"
  elif [ -n "$INSTALLED_MDB" ]; then
    echo "$INSTALLED_MDB"
  else
    echo ""
  fi
}

# --- Helper: convert mariadb package digits to dotted version (e.g. 1011 -> 10.11) ---
mdb_digits_to_version() {
  local digits="$1"
  local len=${#digits}
  if [ "$len" -eq 4 ]; then
    # e.g. 1011 -> 10.11
    echo "${digits:0:2}.${digits:2:2}"
  elif [ "$len" -eq 3 ]; then
    # e.g. 105 -> 10.5
    echo "${digits:0:2}.${digits:2:1}"
  else
    echo "$digits"
  fi
}

# =============================================================
# Capture current installed versions
# =============================================================
PHP_VER=$(php -v 2>/dev/null | head -n1 | awk '{print $2}' | cut -d'-' -f1)
MYSQL_VER=$(mysql --version 2>/dev/null | awk '{print $3}' | tr -d ',')
MARIADB_VER=$(echo "$MYSQL_VER" | sed 's/-MariaDB//')

if [ -z "$PHP_VER" ]; then
  echo -e "${RED}[!!] PHP is not installed. Please install the LAMP stack first.${NC}"
  exit 1
fi

if [ -z "$MARIADB_VER" ]; then
  echo -e "${RED}[!!] MariaDB is not installed. Please install the LAMP stack first.${NC}"
  exit 1
fi

# =============================================================
# Detect latest available versions
# =============================================================
echo ""
echo -e "${CYAN}Checking dnf repositories for latest available versions...${NC}"

TARGET_PHP=$(detect_latest_php)
TARGET_MDB_DIGITS=$(detect_latest_mariadb)
TARGET_MARIADB=$(mdb_digits_to_version "$TARGET_MDB_DIGITS")

if [ -z "$TARGET_PHP" ]; then
  echo -e "${RED}[!!] Could not detect any PHP packages in dnf repos.${NC}"
  exit 1
fi

if [ -z "$TARGET_MDB_DIGITS" ]; then
  echo -e "${RED}[!!] Could not detect any MariaDB server packages in dnf repos.${NC}"
  exit 1
fi

# Extract major.minor from current installed versions for comparison
PHP_MAJOR_MINOR=$(echo "$PHP_VER" | grep -oP '^[0-9]+\.[0-9]+')

echo ""
echo "  ╔═════════════════════════════════════════════╗"
echo "  ║        LAMP STACK  UPGRADE  CHECK           ║"
echo "  ╠═════════════════════════════════════════════╣"
echo "  ║                                             ║"
printf "  ║   PHP      : current %-8s latest %s  ║\n" "$PHP_VER" "$TARGET_PHP"
printf "  ║   MariaDB  : current %-8s latest %s║\n" "$MARIADB_VER" "$TARGET_MARIADB"
echo "  ║                                             ║"
echo "  ╚═════════════════════════════════════════════╝"
echo ""

# --- Track what needs upgrading ---
UPGRADE_PHP=false
UPGRADE_MARIADB=false

if version_gte "$PHP_MAJOR_MINOR" "$TARGET_PHP"; then
  echo -e "${GREEN}[OK] PHP $PHP_VER is already the latest available ($TARGET_PHP)${NC}"
else
  echo -e "${YELLOW}[>>] PHP $PHP_MAJOR_MINOR will be upgraded to $TARGET_PHP${NC}"
  UPGRADE_PHP=true
fi

if version_gte "$MARIADB_VER" "$TARGET_MARIADB"; then
  echo -e "${GREEN}[OK] MariaDB $MARIADB_VER is already the latest available ($TARGET_MARIADB)${NC}"
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
  sudo dnf remove -y php php-* php${PHP_MAJOR_MINOR} php${PHP_MAJOR_MINOR}-* 2>/dev/null || true

  # Install latest PHP and extensions needed for WordPress
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

  echo -e "  ${GREEN}[OK] PHP upgraded to $TARGET_PHP${NC}"
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

  # Remove old MariaDB server packages
  echo "  Removing old MariaDB packages..."
  sudo dnf remove -y mariadb-server mariadb*-server 2>/dev/null || true

  # Install latest MariaDB
  echo "  Installing MariaDB $TARGET_MARIADB..."
  sudo dnf install -y mariadb${TARGET_MDB_DIGITS}-server

  # Start and enable the new MariaDB
  echo "  Starting MariaDB $TARGET_MARIADB..."
  sudo systemctl start mariadb
  sudo systemctl enable mariadb

  echo -e "  ${GREEN}[OK] MariaDB upgraded to $TARGET_MARIADB${NC}"
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

NEW_PHP_MM=$(echo "$NEW_PHP_VER" | grep -oP '^[0-9]+\.[0-9]+')
FINAL_PASS=true
if ! version_gte "$NEW_PHP_MM" "$TARGET_PHP"; then
  FINAL_PASS=false
fi
if ! version_gte "$NEW_MARIADB_VER" "$TARGET_MARIADB"; then
  FINAL_PASS=false
fi

if [ "$FINAL_PASS" = true ]; then
  echo "  ║                                             ║"
  echo "  ║   [OK]  All components upgraded             ║"
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
