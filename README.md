# Laporan Keuangan Harian — iOS, Android-Friendly + GitHub Actions

Project port iOS berdasarkan APK yang diberikan, disusun supaya source dapat diedit dari HP Android dan build iOS dijalankan di GitHub Actions.

## Edit dari HP Android

Mulai dari:

`Source/AppConfig.swift`

Konfigurasi utama seperti URL, splash duration, endpoint lokasi, dan WhatsApp dipusatkan di sana.

## Build cloud

Workflow:

`.github/workflows/ios-build.yml`

Workflow menggunakan runner macOS GitHub Actions untuk menjalankan Xcode. Build dapat dijalankan tanpa memiliki Mac sendiri.

- `signed=false` → verifikasi compile dan menghasilkan `.xcarchive`.
- `signed=true` → membutuhkan Apple signing secrets dan menghasilkan `.ipa`.

Baca:

`Docs/GITHUB_ACTIONS.md`

untuk setup lengkap.

## Penting

GitHub Actions menyediakan mesin macOS/Xcode untuk build, tetapi **Apple signing tetap memerlukan akun/program Apple Developer dan certificate/provisioning profile yang sah**. Tanpa signing, hasil archive tidak menjadi IPA yang siap dipasang ke iPhone.
