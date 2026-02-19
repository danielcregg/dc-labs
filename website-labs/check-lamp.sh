#!/bin/bash

# --- Capture version strings ---
APACHE_VER=$(httpd -v 2>/dev/null | grep "Server version" | sed 's/.*Apache\///' | awk '{print $1}')
PHP_VER=$(php -v 2>/dev/null | head -n1 | awk '{print $2}')
MYSQL_VER=$(mysql --version 2>/dev/null | awk '{print $3}' | tr -d ',')

[ -z "$APACHE_VER" ] && APACHE_VER="NOT FOUND"
[ -z "$PHP_VER" ]    && PHP_VER="NOT FOUND"
[ -z "$MYSQL_VER" ]  && MYSQL_VER="NOT FOUND"

# --- Determine overall pass/fail ---
PASS=true
[[ "$APACHE_VER" == "NOT FOUND" ]] && PASS=false
[[ "$PHP_VER"    == "NOT FOUND" ]] && PASS=false
[[ "$MYSQL_VER"  == "NOT FOUND" ]] && PASS=false

# --- Helper: per-component status icon ---
icon() { [[ "$1" != "NOT FOUND" ]] && echo "OK" || echo "!!"; }

echo ""
echo "  ╔═════════════════════════════════════════════╗"
echo "  ║          LAMP STACK  VERIFICATION           ║"
echo "  ╠═════════════════════════════════════════════╣"
echo "  ║                                             ║"
echo "  ║   [OS]  Linux  (Amazon Linux 2023)          ║"
echo "  ║         └─ Foundation layer                 ║"
echo "  ║                                             ║"
echo "  ╠═════════════════════════════════════════════╣"
printf "  ║   [$(icon $APACHE_VER)]  Apache HTTP Server                 ║\n"
printf "  ║         Version : %-26s║\n" "$APACHE_VER"
echo "  ║         Port    : 80 / 443                  ║"
echo "  ║                                             ║"
printf "  ║   [$(icon $PHP_VER)]  PHP                                  ║\n"
printf "  ║         Version : %-26s║\n" "$PHP_VER"
echo "  ║         Role    : Application layer         ║"
echo "  ║                                             ║"
printf "  ║   [$(icon $MYSQL_VER)]  MariaDB  (MySQL compatible)         ║\n"
printf "  ║         Version : %-26s║\n" "$MYSQL_VER"
echo "  ║         Port    : 3306                      ║"
echo "  ║                                             ║"
echo "  ╠═════════════════════════════════════════════╣"

if [ "$PASS" = true ]; then
  echo "  ║                                             ║"
  echo "  ║   [OK]  All components detected             ║"
  echo "  ║   [OK]  LAMP stack is ready                 ║"
  echo "  ║                                             ║"
  echo "  ║   --> You are ready to install WordPress!   ║"
  echo "  ║                                             ║"
else
  echo "  ║                                             ║"
  echo "  ║   [!!]  One or more components not found    ║"
  echo "  ║   [!!]  Please install the LAMP stack first ║"
  echo "  ║                                             ║"
  echo "  ║   --> Do NOT proceed until all show [OK]    ║"
  echo "  ║                                             ║"
fi

echo "  ╚═════════════════════════════════════════════╝"
echo ""
