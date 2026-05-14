# Tugas Praktikum PBM 2026 - Aplikasi Manajemen Produk

Aplikasi Flutter ini dibuat untuk memenuhi Tugas Praktikum Pemrograman Berbasis Mobile 2026. Aplikasi ini terintegrasi penuh dengan REST API asisten praktikum, mencakup fitur autentikasi Bearer Token, dan menggunakan desain antarmuka (UI) *Dark Glassmorphism* yang modern dan elegan.

## ✨ Fitur Utama

- **Autentikasi Aman**: Login menggunakan NIM dan secara otomatis menyimpan Bearer Token secara lokal menggunakan package `flutter_secure_storage`.
- **Struktur OOP yang Baik**: Menerapkan Model Class yang mendalam (`UserModel`, `Product`, `RoleModel`, `ClassModel`, `StoreModel`) untuk pemrosesan JSON dari API.
- **Katalog Draft Produk**: Dapat melihat daftar draft produk yang terikat pada akun mahasiswa.
- **Tambah & Hapus Produk**: Menambahkan produk ke draft dan fitur menghapus produk (soft-delete).
- **Submit Tugas**: Fitur utama untuk mengumpulkan repository GitHub ke *dashboard* asisten praktikum.

## 🎨 Desain Antarmuka (Premium UI)

Aplikasi ini dirombak dengan tema **Dark Glassmorphism** dipadukan dengan aksen *Neon Cyberpunk*:
- **Glass Effect**: Form dan *card* memiliki efek kaca transparan menggunakan `BackdropFilter`.
- **Smooth Animations**: Perpindahan halaman dan notifikasi pop-up menggunakan animasi halus (FadeIn, ZoomIn, BounceIn) dengan bantuan `animate_do`.
- **Custom Widget**: Textfield modern dengan ikon, warna menyala, dan *validation form* yang informatif.

## 📸 Screenshot

*(File gambar screenshot tersedia di dalam folder utama repository ini)*
- Halaman Login
- Halaman Katalog Draft
- Halaman Tambah Produk
- Halaman Pengumpulan Tugas

## 🚀 Cara Menjalankan Aplikasi

1. Pastikan Anda sudah menginstal Flutter SDK di komputer Anda.
2. Clone repository ini:
   ```bash
   git clone https://github.com/jodie29/TugasPBM.git
   ```
3. Masuk ke dalam direktori project dan unduh semua dependensi:
   ```bash
   cd TugasPBM
   flutter pub get
   ```
4. Jalankan aplikasi (Contoh menjalankan di platform Windows):
   ```bash
   flutter run -d windows
   ```

## 📦 Package yang Digunakan

- `http` - Menangani semua *HTTP Request* ke server API.
- `flutter_secure_storage` - Menyimpan Auth Token dengan standar keamanan tinggi.
- `google_fonts` - Memberikan tipografi *Outfit* yang modern.
- `animate_do` - Membuat aplikasi terasa hidup dengan interaksi animasi yang *smooth*.
