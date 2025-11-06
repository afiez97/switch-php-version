#!/bin/bash
# Auto PHP version switcher for Apache/Nginx 💻
# Dibuat oleh Afiez — boleh dipasang dengan nama bebas 🧠✨

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
SPINNERS=("⏳" "🔄" "⚙" "🌀" "✨" "💫")

loading() {
  local message=$1
  for i in {1..3}; do
    for s in "${SPINNERS[@]}"; do
      echo -ne "\r$s $message..."
      sleep 0.2
    done
  done
  echo -ne "\r✅ $message selesai!\n"
}

list_versions() {
  echo -e "${YELLOW}🔍 Mencari versi PHP yang tersedia...${RESET}"
  local versions=($(ls /usr/bin/php* | grep -Eo '[0-9]+\.[0-9]+' | sort -u))
  
  if [ ${#versions[@]} -eq 0 ]; then
    echo -e "${RED}❌ Tiada versi PHP ditemui.${RESET}"
    exit 1
  fi

  echo -e "\n${GREEN}✅ Versi PHP yang tersedia:${RESET}"
  local current="$(php -v | head -n1 | grep -Eo '[0-9]+\.[0-9]+')"
  for v in "${versions[@]}"; do
    if [[ "$current" == "$v" ]]; then
      echo -e "  👉 PHP $v ${YELLOW}(aktif sekarang)${RESET}"
    else
      echo -e "  • PHP $v"
    fi
  done
  echo ""
  echo -e "${YELLOW}Gunakan: <command> <versi> untuk tukar.${RESET}"
  exit 0
}

current_version() {
  local current="$(php -v | head -n1)"
  echo -e "${GREEN}🧩 Versi PHP aktif sekarang:${RESET}"
  echo "  $current"
  echo ""
  exit 0
}

if [ "$ACTION" == "list" ]; then
  list_versions
fi

if [ "$ACTION" == "current" ]; then
  current_version
fi

VERSION=$ACTION

echo -e "${YELLOW}🔁 Menukar PHP ke versi $VERSION...${RESET}"

if [ ! -f "/usr/bin/php$VERSION" ]; then
  echo -e "${YELLOW}⚠ PHP $VERSION belum dipasang. Memasang sekarang...${RESET}"
  sudo apt install -y php$VERSION php$VERSION-cli php$VERSION-common php$VERSION-fpm >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Gagal memasang PHP $VERSION.${RESET}"
    exit 1
  fi
fi

loading "Menukar PHP CLI ke versi $VERSION"
sudo update-alternatives --set php /usr/bin/php$VERSION >/dev/null 2>&1

if systemctl list-units --type=service | grep -q "apache2.service"; then
  echo -e "${YELLOW}🌐 Apache dikesan. Menukar modul PHP...${RESET}"
  CURRENT_MOD=$(ls /etc/apache2/mods-enabled | grep php | cut -d'.' -f1 | uniq)
  if [ -n "$CURRENT_MOD" ]; then
    loading "Menonaktifkan modul $CURRENT_MOD"
    sudo a2dismod $CURRENT_MOD >/dev/null 2>&1
  fi
  loading "Mengaktifkan modul php$VERSION"
  sudo a2enmod php$VERSION >/dev/null 2>&1
  loading "Restart Apache"
  sudo systemctl restart apache2
fi

if systemctl list-units --type=service | grep -q "nginx.service"; then
  echo -e "${YELLOW}🌐 Nginx dikesan. Menukar versi PHP-FPM...${RESET}"
  for svc in $(systemctl list-units --type=service | grep php | grep fpm | awk '{print $1}'); do
    sudo systemctl stop $svc >/dev/null 2>&1
  done
  loading "Mengaktifkan PHP-FPM ($VERSION)"
  sudo systemctl enable php$VERSION-fpm >/dev/null 2>&1
  sudo systemctl start php$VERSION-fpm >/dev/null 2>&1
  loading "Restart Nginx"
  sudo systemctl restart nginx
fi

echo -e "${GREEN}🎉 PHP kini berjaya ditukar kepada versi: $(php -v | head -n 1)${RESET}"
echo -e "💡 Gunakan 'php -v' atau '<command> current' untuk sahkan versi semasa."
