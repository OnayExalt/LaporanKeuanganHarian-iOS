# EDIT PROJECT DARI HP ANDROID

Project ini sengaja dirapikan agar source code mudah dibuka dengan editor teks Android.

## Aplikasi Android yang dapat digunakan

Gunakan editor teks/code apa pun yang bisa membuka folder dan file `.swift`, misalnya editor kode Android yang Anda sukai.

## File penting

`Source/AppConfig.swift`
→ konfigurasi utama.

`Source/ContentViewController.swift`
→ WebView, splash, JavaScript bridge, invoice snapshot, kamera.

`Source/LocationManager.swift`
→ live location dan pengiriman koordinat.

`Source/AppDelegate.swift`
→ lifecycle aplikasi.

`Resources/Info.plist`
→ permission iOS dan konfigurasi aplikasi.

`Resources/LaunchScreen.storyboard`
→ launch screen.

`Resources/Assets.xcassets/`
→ logo dan ikon aplikasi.

## Workflow dari Android

1. Download ZIP.
2. Ekstrak.
3. Edit file Swift/konfigurasi.
4. Simpan.
5. Upload project ke GitHub/GitLab atau layanan cloud build iOS.
6. Build dengan macOS/Xcode/CI yang menyediakan Xcode.
7. Sign menggunakan Apple Developer.
8. Export IPA/TestFlight.

## Penting

Jangan mengubah ekstensi `.swift` menjadi `.java` atau `.kt`. Ini adalah source iOS Swift.
