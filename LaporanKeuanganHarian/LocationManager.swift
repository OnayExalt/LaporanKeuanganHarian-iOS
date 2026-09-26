import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var timer: Timer?
    private(set) var username = ""
    private var lastLocation: CLLocation?
    private var isRunning = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    func start(username: String) {
        self.username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !self.username.isEmpty else { return }
        isRunning = true
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            beginUpdates()
        default:
            break
        }
    }

    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        manager.stopUpdatingLocation()
    }

    private func beginUpdates() {
        guard isRunning else { return }
        manager.startUpdatingLocation()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: AppConfig.locationSendInterval, repeats: true) { [weak self] _ in
            self?.sendLastLocation()
        }
        sendLastLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            beginUpdates()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }

    private func sendLastLocation() {
        guard let location = lastLocation, !username.isEmpty else {
            manager.requestLocation()
            return
        }

        var components = URLComponents(url: AppConfig.locationAPIURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "action", value: "location"),
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "accuracy", value: String(location.horizontalAccuracy)),
            URLQueryItem(name: "timestamp", value: ISO8601DateFormatter().string(from: location.timestamp))
        ]
        guard let url = components?.url else { return }
        URLSession.shared.dataTask(with: url).resume()
    }
}
