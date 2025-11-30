# Local Mail Server Infrastructure (Ubuntu + Mikrotik)

![Project Status](https://img.shields.io/badge/status-stable-success?style=for-the-badge)
![OS](https://img.shields.io/badge/Ubuntu_Server-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu)
![Network](https://img.shields.io/badge/RouterOS-Mikrotik-blue?style=for-the-badge)

**Tugas Akhir Mata Kuliah Sistem Operasi**
Dirancang dan diimplementasikan sebagai infrastruktur email mandiri yang aman dalam jaringan lokal.

---

## 👥 Tim Pengembang

| NIM | Nama |
| :--- | :--- |
| **[NIM ABDUL]** | Abdul |
| **[NIM ADIB]** | Adib |
| **[NIM DEA]** | Dea |
| **[NIM ICIN]** | Icin |

*(Silakan lengkapi NIM masing-masing)*

---

## 📖 Tentang Proyek Ini

Repositori ini berisi dokumentasi dan file konfigurasi ("otak") dari infrastruktur Mail Server lokal yang kami bangun.

Proyek ini bertujuan untuk mensimulasikan lingkungan server produksi di mana email dikirim dan diterima secara aman dalam domain lokal (`kelompok4.net`). Sistem ini memisahkan peran antara router gateway (Mikrotik) dan server aplikasi (Ubuntu), serta memaksa penggunaan enkripsi TLS/SSL untuk semua komunikasi email.

### Arsitektur & Topologi Jaringan
Kami menggunakan topologi Hybrid di mana Mikrotik berfungsi sebagai pusat jaringan: Gateway Internet (via Wireless Uplink), DNS Server lokal, dan DHCP Server. Server Ubuntu terhubung via kabel, sedangkan klien terhubung via Wi-Fi.

![Topologi Jaringan](Topologi_Jaringan.jpg)
*Skema Topologi Jaringan Mail Server Kelompok 4.*

---

## 🔥 Teknologi yang Digunakan (Tech Stack)

Kami mengintegrasikan berbagai perangkat lunak open-source industri untuk membangun sistem ini:

* **📧 Mail Transfer Agent (MTA): Postfix**
    * Menangani pengiriman email (SMTP).
    * Dikonfigurasi aman menggunakan port submission **587 (SMTPS)** dengan TLS dan otentikasi SASL.
* **📥 Mail Delivery Agent (MDA): Dovecot**
    * Menangani penyimpanan email (menggunakan format modern **Maildir**) dan pengambilan email.
    * Melayani akses via protokol **IMAPS (Port 993)**.
* **🖥️ Webmail Interface: Roundcube**
    * Klien email berbasis web yang berjalan di atas Apache Web Server, PHP, dan MariaDB.
    * Akses dipaksa melalui **HTTPS**.
* **🌐 Network Core: Mikrotik RouterOS**
    * Manajemen routing, NAT, dan resolusi domain lokal.

---

## 📂 Struktur Repositori

File-file dalam repositori ini adalah salinan konfigurasi dari server produksi kami:

* `/mikrotik_config`: Berisi file script konfigurasi router Mikrotik (`.rsc`).
* `/ubuntu_server_config`: Berisi file konfigurasi inti dari layanan server Ubuntu:
    * `/netplan`: Konfigurasi IP statis server.
    * `/postfix`: Konfigurasi utama (`main.cf`) dan master service (`master.cf`).
    * `/dovecot`: Konfigurasi otentikasi, penyimpanan maildir, dan SSL.
    * `/apache2`: Konfigurasi VirtualHost untuk webmail HTTPS.
    * `/roundcube`: Konfigurasi koneksi SMTP/IMAP Roundcube.

---

## 🛠️ Panduan Replikasi (How to Replicate)

Berikut adalah ringkasan langkah-langkah untuk membangun ulang sistem ini menggunakan konfigurasi yang tersedia:

1.  **Setup Mikrotik:** Import file `/mikrotik_config/config_mikrotik_final.rsc` ke router Mikrotik yang sudah di-reset untuk mengatur jaringan dasar.
2.  **Setup Server Ubuntu:** Install Ubuntu Server 24.04 LTS dan hubungkan ke port Ether2 Mikrotik.
3.  **Install Paket:** Install dependensi yang diperlukan: `postfix`, `dovecot-core`, `dovecot-imapd`, `apache2`, `mariadb-server`, `php`, dan `roundcube`.
4.  **Generate SSL:** Buat Self-Signed Certificate menggunakan OpenSSL di `/etc/ssl/`.
5.  **Terapkan Konfigurasi:** Salin file-file dari folder `/ubuntu_server_config/` ke lokasi yang sesuai di server (`/etc/postfix`, `/etc/dovecot`, dll).
6.  **Setup Database & User:** Konfigurasi database untuk Roundcube dan buat user Linux untuk pengujian.
7.  **Restart Service:** Restart `apache2`, `postfix`, dan `dovecot` untuk menerapkan perubahan.

---

## 🐛 Troubleshooting "Hall of Fame"

Proses pengembangan ini tidak lepas dari tantangan. Berikut adalah beberapa masalah kritis yang berhasil kami selesaikan:

### 1. Kegagalan Otentikasi SMTP di Roundcube
* **Masalah:** Roundcube gagal mengirim email dengan error "Authentication failed". Log server menunjukkan Roundcube mengirimkan string literal `"%n"` sebagai username, bukan nama pengguna asli.
* **Solusi:** Kami mengembalikan konfigurasi Roundcube menggunakan variabel `%u` (username lengkap dengan domain), dan mengonfigurasi Dovecot (`auth_username_format = %n`) agar otomatis memotong domain sebelum melakukan pengecekan password ke sistem Linux.

### 2. Postfix Error 4.3.5 Server Configuration
* **Masalah:** Postfix menolak semua pengiriman email dengan status `bounced` dan error `4.3.5 Server configuration error`. Log menunjukkan peringatan bahwa Postfix tidak mengenali parameter restriksi.
* **Solusi:** Ditemukan kesalahan pengetikan (typo) fatal pada file `/etc/postfix/main.cf`. Parameter `smtpd_recipient_restrictions` menggunakan pemisah **titik (`.`)** yang seharusnya adalah **koma (`,`)**. Setelah diganti menjadi koma, sistem berjalan normal.

---

## 🛡️ Catatan Keamanan (Security Notice)

Demi keamanan infrastruktur, beberapa file dan informasi sensitif **TIDAK DISERTAKAN** dalam repositori publik ini.

Hal ini mencakup:

1.  **Private Key SSL:** File kunci privat server (`.key`) yang digunakan untuk enkripsi TLS/SSL tidak diunggah. Mempublikasikan private key akan membahayakan keamanan seluruh komunikasi server.
2.  **Kredensial Database:** Password koneksi database di dalam file konfigurasi Roundcube telah disensor atau dihapus sebelum diunggah.

---
**Tugas Akhir Sistem Operasi - Kelompok 4 - [Tahun]**