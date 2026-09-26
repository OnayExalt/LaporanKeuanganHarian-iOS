# KONFIGURASI APLIKASI

File ini adalah panduan edit cepat dari HP Android.

## Yang paling sering diedit

Buka file:
`Source/AppConfig.swift`

Ubah bagian berikut:

- `appName` = nama aplikasi
- `websiteURL` = alamat halaman utama
- `googleScriptURL` = endpoint Google Apps Script
- `whatsappURL` = nomor WhatsApp dukungan
- `locationAPIURL` = endpoint pengiriman lokasi
- `splashDuration` = durasi splash dalam detik
- `locationSendInterval` = interval kirim lokasi dalam detik

## Contoh

`static let splashDuration: TimeInterval = 5.0`

Artinya splash tampil 5 detik.

## Catatan

Setelah mengedit Swift, file tersebut perlu dibuild menggunakan Xcode/macOS atau CI/cloud build iOS. Android dapat digunakan untuk mengedit source, mengelola file, Git, dan ZIP, tetapi tidak menyediakan Apple iOS SDK secara native.
