#!/bin/bash
# Auto PHP version switcher (manual-safe method) 💻
# Dibuat oleh Afiez — versi 4.5.1 (list tunjuk current) 🧠✨

if [ -z "$1" ]; then
  echo "📘 Penggunaan:"
  echo "  <command> <versi>     → Tukar versi PHP"
  echo "  <command> list        → Senarai semua versi PHP yang ada"
  echo "  <command> current     → Papar versi PHP aktif sekarang"
  echo ""
  echo "Contoh: php-switch 8.3"
  exit 1
fi

ACTION=$1
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# --- Animasi ringkas ---
loading() {
  local message=$1
  echo -ne "🔄 $message..."
  sleep 1
  echo -ne "\r✅ $message selesai!\n"
}

# --- Senarai versi PHP ---
if [ "$ACTION" == "list" ]; then
  echo -e "${YELLOW}🔍 Mencari versi PHP yang tersedia...${RESET}"
  # Kumpul versi yang tersedia (contoh: /usr/bin/php8.2, /usr/bin/php8.3)
  versions=($(ls /usr/bin/php[0-9]* 2>/dev/null | sed -E 's#.*/php([0-9]+\.[0-9]+)$#\1#' | sort -u))

  if [ ${#versions[@]} -eq 0 ]; then
    echo -e "${RED}❌ Tiada versi PHP ditemui.${RESET}"
    exit 1
  fi

  # Dapatkan versi PHP aktif sekarang dengan lebih tepat
  current_bin="$(readlink -f "$(command -v php)")"
  current="$(echo "$current_bin" | grep -Eo '[0-9]+\.[0-9]+')"
  echo -e "\n${GREEN}✅ Versi PHP yang tersedia:${RESET}"
  for v in "${versions[@]}"; do
    if [[ "$current" == "$v" ]]; then
      echo -e "  👉 PHP $v ${YELLOW}(aktif sekarang)${RESET}"
    else
      echo -e "  • PHP $v"
    fi
  done
  echo ""
  exit 0
fi

# --- Papar versi semasa ---
if [ "$ACTION" == "current" ]; then
  current="$(php -v | head -n1)"
  echo -e "${GREEN}🧩 Versi PHP aktif sekarang:${RESET}"
  echo "  $current"
  echo ""
  exit 0
fi

VERSION=$ACTION
echo -e "${YELLOW}🔁 Menukar PHP ke versi $VERSION...${RESET}"

# --- Semak versi ada ---
if [ ! -f "/usr/bin/php$VERSION" ]; then
  echo -e "${YELLOW}⚠ PHP $VERSION belum dipasang. Memasang sekarang...${RESET}"
  sudo apt install -y php$VERSION php$VERSION-cli php$VERSION-common php$VERSION-fpm >/dev/null 2>&1
fi

# --- Tukar PHP CLI ---
loading "Menukar PHP CLI ke versi $VERSION"
sudo update-alternatives --set php /usr/bin/php$VERSION >/dev/null 2>&1

# ==========================
# 🔧 Apache Handler Section
# ==========================
if systemctl is-active --quiet apache2; then
  echo -e "${YELLOW}🌐 Apache dikesan. Menukar modul PHP...${RESET}"
  
  CURRENT_MOD=$(ls /etc/apache2/mods-enabled | grep '^php' | cut -d'.' -f1 | uniq | head -n1)
  if [ -n "$CURRENT_MOD" ] && [ "$CURRENT_MOD" != "php$VERSION" ]; then
    loading "Menonaktifkan modul $CURRENT_MOD"
    sudo a2dismod "$CURRENT_MOD" >/dev/null 2>&1
  fi

  if [ ! -f "/usr/lib/apache2/modules/libphp$VERSION.so" ]; then
    echo -e "${YELLOW}⚙️  Memasang modul Apache untuk PHP $VERSION...${RESET}"
    sudo apt install -y libapache2-mod-php$VERSION >/dev/null 2>&1
  fi

  loading "Mengaktifkan modul php$VERSION"
  sudo a2enmod "php$VERSION" >/dev/null 2>&1
  sleep 1
  
  echo -e "${YELLOW}🔍 Menyemak konfigurasi Apache...${RESET}"
  sudo apachectl configtest >/tmp/apache_check.log 2>&1
  if grep -q "Syntax OK" /tmp/apache_check.log; then
    loading "Restart Apache"
    sudo systemctl restart apache2 >/dev/null 2>&1
    echo -e "${GREEN}✅ Apache berjaya dimulakan semula.${RESET}"
  else
    echo -e "${RED}❌ Konfigurasi Apache tidak sah.${RESET}"
    cat /tmp/apache_check.log
    exit 1
  fi
fi

# ==========================
# 🔧 Nginx Handler Section
# ==========================
if systemctl is-active --quiet nginx; then
  echo -e "${YELLOW}🌐 Nginx dikesan. Menukar PHP-FPM...${RESET}"
  for svc in $(systemctl list-units --type=service | grep php | grep fpm | awk '{print $1}'); do
    sudo systemctl stop $svc >/dev/null 2>&1
  done
  sudo systemctl enable php$VERSION-fpm >/dev/null 2>&1
  sudo systemctl start php$VERSION-fpm >/dev/null 2>&1
  sudo systemctl restart nginx >/dev/null 2>&1
  echo -e "${GREEN}✅ Nginx dan PHP-FPM kini versi $VERSION.${RESET}"
fi

# ==========================
# 🎉 Selesai
# ==========================
echo -e "${GREEN}🎉 PHP kini berjaya ditukar kepada versi: $(php -v | head -n 1)${RESET}"
echo -e "💡 Gunakan 'php -v' atau '<command> current' untuk sahkan versi semasa."
