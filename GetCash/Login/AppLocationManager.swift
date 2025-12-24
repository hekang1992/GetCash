//
//  AppLocationManager.swift
//  GetCash
//
//  Created by hekang on 2025/12/24.
//

import CoreLocation

final class AppLocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
    private var completion: (([String: String]?) -> Void)?
    
    private var debounceWorkItem: DispatchWorkItem?
    
    private let debounceInterval: TimeInterval = 2.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getCurrentLocation(completion: @escaping ([String: String]?) -> Void) {
        self.completion = completion
        
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.requestLocationIfNeeded()
        }
        
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + debounceInterval,
            execute: workItem
        )
    }
    
    private func requestLocationIfNeeded() {
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
        completion?(result)
    }
}

// MARK: - CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else if manager.authorizationStatus == .denied ||
                    manager.authorizationStatus == .restricted {
            finish(nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self = self else { return }
            
            let placemark = placemarks?.first
            
            let locationJson: [String: String] = [
                "local": placemark?.administrativeArea ?? "",
                "enough": placemark?.isoCountryCode ?? "",
                "opting": placemark?.country ?? "",
                "mutation": placemark?.thoroughfare ?? "",
                "basic": placemark?.locality ?? "",
                "evolutionary": placemark?.subLocality ?? "",
                "perturb": String(format: "%.6f", location.coordinate.latitude),
                "compute": String(format: "%.6f", location.coordinate.longitude),
            ]
            
            self.finish(locationJson)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finish(nil)
    }
}
