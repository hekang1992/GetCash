//
//  AppLocationManager.swift
//  GetCash
//
//  Created by hekang on 2025/12/24.
//

import CoreLocation

class AppLocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private var completion: (([String: String]?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getCurrentLocation(completion: @escaping ([String: String]?) -> Void) {
        self.completion = completion
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            finish(nil)
            
        @unknown default:
            finish(nil)
        }
    }
    
    private func finish(_ result: [String: String]?) {
        locationManager.stopUpdatingLocation()
        completion?(result)
    }
}

// MARK: - CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            
        case .denied, .restricted:
            finish(nil)
            
        case .notDetermined:
            break
            
        @unknown default:
            finish(nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self = self else { return }
            
            let placemark = placemarks?.first
            
            let locationJson: [String: String] = [
                "courtesies": placemark?.administrativeArea ?? "",
                "delineated": placemark?.isoCountryCode ?? "",
                "spoken": placemark?.country ?? "",
                "particulars": placemark?.thoroughfare ?? "",
                "communicated": String(format: "%.6f", location.coordinate.latitude),
                "palate": String(format: "%.6f", location.coordinate.longitude),
                "fever": placemark?.locality ?? "",
                "allayed": placemark?.subLocality ?? ""
            ]
            
            self.finish(locationJson)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finish(nil)
    }
}
