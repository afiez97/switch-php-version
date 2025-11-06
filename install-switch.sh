#!/bin/bash
# Installer untuk Auto PHP Switcher
# Ditulis oleh Afiez 💻✨

echo "🧠 Selamat datang ke pemasang PHP Switcher!"
read -p "Masukkan nama command yang anda mahu (contoh: php-switch): " CMD_NAME

if [ -z "$CMD_NAME" ]; then
  echo "❌ Nama command tidak boleh kosong."
  exit 1
fi

TARGET="/usr/local/bin/$CMD_NAME"

# Salin skrip utama
echo "📦 Menyalin skrip ke $TARGET..."
sudo cp ./afiez-switch.sh "$TARGET"

# Jadikan boleh dijalankan
sudo chmod +x "$TARGET"

echo ""
echo "✅ Selesai dipasang!"
echo "Anda kini boleh guna dengan:"
echo ""
echo "   $CMD_NAME list"
echo "   $CMD_NAME current"
echo "   $CMD_NAME 8.3"
echo ""
echo "💡 Skrip disimpan di: $TARGET"
