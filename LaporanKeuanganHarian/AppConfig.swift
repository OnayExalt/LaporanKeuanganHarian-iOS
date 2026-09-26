import Foundation

enum AppConfig {
    static let appName = "Laporan Keuangan Harian"
    static let websiteURL = URL(string: "https://nexusdispora.my.canva.site/aplikasi-keuangan-oni-ramadhan-")!
    static let googleScriptURL = URL(string: "https://script.google.com/macros/s/AKfycby2X_laGutrmb-RNiUFH6TbA7nVKnKEflIP_o2fFtNOXctoGGxHSga2GS6RqNcNNP99/exec")!
    static let whatsappURL = URL(string: "https://wa.me/6283835906637")!
    // Android APK exposes LOCATION_API_URL as a configurable endpoint and uses action=location&username=.
    // The observed Google Apps Script endpoint is used here as the default location endpoint.
    static let locationAPIURL = googleScriptURL
    static let splashDuration: TimeInterval = 5.0
    static let locationSendInterval: TimeInterval = 60.0
}
