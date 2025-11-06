## 🧠 PHP Switcher (v4.5.1)

Auto PHP Version Switcher + Installer Prompt. Tukar versi PHP (CLI, Apache, Nginx) dengan satu command — ringkas, laju, dan fun 🎉

Kini installer membenarkan anda pilih nama command sendiri (contoh: php-switch) supaya mudah diingat.

---

## ✨ Ciri Utama

- Tukar versi PHP dengan satu arahan (contoh: 8.2, 8.3)
- Auto detect & restart Apache / Nginx (jika sedang berjalan)
- Senarai semua versi PHP yang dipasang dan highlight versi aktif
- Papar versi PHP aktif sekarang
- Installer tanya nama command (customizable)
- Animasi loading dengan emoji 😎

Nota: Jika versi yang diminta belum dipasang, skrip akan cuba memasang pakej yang diperlukan menggunakan apt.

---

## 🧩 Keperluan

- Sistem berasaskan Debian/Ubuntu (apt tersedia)
- Akses sudo
- Optional: Apache2 dan/atau Nginx (jika anda guna web server)

---

## 💾 Pemasangan

1) Clone repo ini dan masuk ke foldernya:

```bash
git clone https://github.com/afiez97/switch-php-version.git
cd switch-php-version
```

2) Jalankan installer dan pilih nama command (contoh: php-switch):

```bash
bash install-switch.sh
```

Selepas selesai, anda boleh guna command pilihan anda dari mana-mana, contohnya php-switch.

---

## 🚀 Cara Guna (paling penting)

Gantikan php-switch dengan nama command yang anda pilih semasa pemasangan.

- Tukar versi PHP:

  ```bash
  php-switch 8.3
  ```

- Senarai semua versi dan highlight yang aktif sekarang:

  ```bash
  php-switch list
  ```

- Papar versi PHP aktif sekarang:

  ```bash
  php-switch current
  ```

---

## 💻 Contoh Output (ringkas)

```text
🔁 Menukar PHP ke versi 8.3...
✅ Menukar PHP CLI ke versi 8.3 selesai!
🌐 Apache dikesan. Menukar modul PHP...
💫 Mengaktifkan modul php8.3
✅ Apache berjaya dimulakan semula.
🎉 PHP kini berjaya ditukar kepada versi: PHP 8.3.12 (cli)
💡 Gunakan 'php -v' atau 'php-switch current' untuk sahkan versi semasa.
```

---

## 🧪 Cara Skrip Bekerja (ringkas)

- CLI: update-alternatives akan diset ke /usr/bin/phpX.Y
- Apache: a2dismod phpX lama → a2enmod phpX.Y → restart apache2 (hanya jika Apache aktif)
- Nginx: hentikan servis php-fpm lain → enable/start phpX.Y-fpm → restart nginx (hanya jika Nginx aktif)

---

## 🔧 Penyelesaian Masalah

- Command tidak ditemui selepas install:
  - Pastikan install-switch.sh berjaya dan command disalin ke /usr/local/bin.
  - Sahkan dengan: `which php-switch` (atau nama command anda).

- Versi tidak tersenarai di list:
  - Pastikan pakej phpX.Y dipasang. Skrip akan cuba `apt install phpX.Y ...` secara automatik jika belum ada.

- Apache gagal restart (Syntax OK tiada):
  - Jalankan `sudo apachectl configtest` dan baiki konfigurasi yang rosak, kemudian cuba semula.

---

## 📁 Struktur Repo

- `install-switch.sh` — Installer: tanya nama command dan setup automatik
- `afiez-switch.sh` — Skrip utama (dipasang ke /usr/local/bin/<nama-command>)
- `README.md` — Dokumen ini

---

## 🧑‍💻 Kredit

Ditulis oleh Afiez — Software Developer @ Olive Intelligence Sdn. Bhd.

Hubungi: mohdafiez7@gmail.com
