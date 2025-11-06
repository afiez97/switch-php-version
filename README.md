
🧠 PHP Switcher (v4.1)
Auto PHP Version Switcher + Installer Prompt 😄
PHP Switcher ialah skrip Bash fleksibel untuk tukar versi PHP (CLI, Apache, dan Nginx) dengan mudah.

Kini ada installer yang akan tanya nama command custom, jadi tak terikat dengan afiez-switch sahaja 🎉

✨ Ciri Utama
✅ Tukar versi PHP dengan satu arahan

✅ Auto detect & restart Apache / Nginx

✅ Senarai semua versi PHP yang dipasang

✅ Papar versi PHP aktif sekarang

✅ Installer tanya nama command (contoh: php-switch)

✅ Animasi emoji loading comel 😎

💾 Cara Pasang
1️⃣ Clone repository:
git clone https://github.com/<username>/php-switcher.git
cd php-switcher

2️⃣ Jalankan installer:
bash install-switch.sh

🧩 Skrip akan tanya:
Masukkan nama command yang anda mahu (contoh: php-switch):

Masukkan nama pilihan anda, contohnya:
php-switch

Selesai! 🎉

🚀 Cara Guna
🔁 Tukar versi PHP:
php-switch 8.3

📋 Lihat semua versi PHP yang ada:
php-switch list

🔎 Lihat versi aktif sekarang:
php-switch current


💻 Contoh Output
🔁 Menukar PHP ke versi 8.3...
⏳ Menukar PHP CLI ke versi 8.3...
✅ Menukar PHP CLI ke versi 8.3 selesai!
🌐 Apache dikesan. Menukar modul PHP...
🌀 Menonaktifkan modul php7.4...
💫 Mengaktifkan modul php8.3...
⚙ Restart Apache...
✅ Restart Apache selesai!
🎉 PHP kini berjaya ditukar kepada versi: PHP 8.3.12 (cli)
💡 Gunakan 'php -v' atau 'php-switch current' untuk sahkan versi semasa.


📜 Fail Dalam Repo
Fail	Fungsi
install-switch.sh	Installer — tanya nama command dan setup automatik
afiez-switch.sh	Skrip utama (boleh rename ikut command pilihan)
README.md	Dokumentasi penggunaan dan pemasangan


⚙️ Kod: install-switch.sh
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

echo "📦 Menyalin skrip ke $TARGET..."
sudo cp ./afiez-switch.sh "$TARGET"

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


🧩 Kod Utama: afiez-switch.sh
(Fungsi penuh untuk tukar, list, dan semak versi PHP)

📄 Lihat skrip penuh di sini

🧑‍💻 Dibuat oleh
Afiez — Software Developer @ Olive Intelligence Sdn. Bhd.

💌 mohdafiez7@gmail.com
