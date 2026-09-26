# Build iOS dari Android memakai GitHub Actions

Anda tidak perlu Mac untuk menjalankan build. HP Android dipakai untuk mengedit/upload repository; GitHub Actions menjalankan Xcode pada runner macOS.

## 1. Buat repository GitHub

Buat repository baru, misalnya `LaporanKeuanganHarian-iOS`, lalu upload seluruh isi folder project ini. Pastikan folder berikut ikut ter-upload:

- `.github/workflows/ios-build.yml`
- `scripts/install-signing.sh`
- `scripts/cleanup-signing.sh`
- `scripts/ExportOptions.plist`
- `LaporanKeuanganHarian.xcodeproj`
- folder `LaporanKeuanganHarian`

## 2. Build tanpa signing terlebih dahulu

Buka tab **Actions** → workflow **Build iOS** → **Run workflow**.

Untuk `signed`, pilih **false**.

Hasilnya adalah `.xcarchive`. Ini hanya untuk memastikan source project dapat dikompilasi oleh Xcode cloud runner; archive ini belum bisa dipasang ke iPhone.

## 3. Untuk IPA yang bisa dipasang di iPhone

Anda membutuhkan Apple Developer signing material:

- Apple Distribution/Development certificate dalam `.p12`
- password `.p12`
- provisioning profile `.mobileprovision`
- Team ID Apple Developer
- nama provisioning profile

GitHub Actions menyimpan material tersebut sebagai **repository secrets**, bukan di source code. GitHub mendokumentasikan penggunaan secrets untuk credentials dan signing certificate pada runner macOS.

## 4. Secrets yang diperlukan

Di GitHub:

**Repository → Settings → Secrets and variables → Actions → New repository secret**

Buat:

`IOS_CERTIFICATE_BASE64`

Base64 dari file `.p12`.

`IOS_CERTIFICATE_PASSWORD`

Password `.p12`.

`IOS_PROVISIONING_PROFILE_BASE64`

Base64 dari `.mobileprovision`.

`IOS_KEYCHAIN_PASSWORD`

Password acak untuk keychain sementara di runner.

`IOS_DEVELOPMENT_TEAM`

Apple Developer Team ID.

`IOS_PROVISIONING_PROFILE_NAME`

Nama profile provisioning yang cocok dengan bundle ID.

## 5. ExportOptions.plist

File `scripts/ExportOptions.plist` berisi:

`REPLACE_WITH_PROFILE_NAME`

Ganti dengan nama provisioning profile Anda.

Bundle ID project saat ini:

`com.laporankeuanganharian.ios`

Jika Anda mengubah bundle ID, ubah juga key provisioning profile di `ExportOptions.plist`.

## 6. Jalankan signed build

Actions → Build iOS → Run workflow → `signed = true`.

Jika semua certificate/profile cocok, workflow menghasilkan artifact:

`LaporanKeuanganHarian-IPA`

Di dalamnya terdapat file `.ipa`.

## 7. Catatan keamanan

Jangan memasukkan `.p12`, password, private key, atau provisioning profile rahasia langsung ke repository. Gunakan GitHub Actions Secrets. GitHub juga menyarankan prinsip least privilege untuk credentials yang dipakai workflow.

## 8. Catatan runner

Workflow menggunakan runner `macos-15`. GitHub menyediakan runner macOS untuk pekerjaan Xcode/iOS; label runner yang tersedia dapat berubah, sehingga jika GitHub mengganti image, label runner dapat diperbarui di workflow.
