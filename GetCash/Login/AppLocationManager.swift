//
//  AppLocationManager.swift
//  GetCash
//
//  Created by hekang on 2025/12/24.
//

import UIKit
import Foundation
import CoreLocation

class AppLocationManager: NSObject {
    
    static let shared = AppLocationManager()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var completion: (([String: String]?) -> Void)?
    private var debounceWorkItem: DispatchWorkItem?
    
    private let debounceInterval: TimeInterval = 2.0
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getCurrentLocation(completion: @escaping ([String: String]?) -> Void) {
        self.completion = completion
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
            
        case .denied, .restricted:
            finish(nil)
            
        @unknown default:
            finish(nil)
        }
    }
    
    private func startLocationUpdate() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func finish(_ result: [String: String]?) {
        DispatchQueue.main.async {
            self.completion?(result)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
            
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
        
        locationManager.stopUpdatingLocation()
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            
            self.geocoder.reverseGeocodeLocation(location) { placemarks, _ in
                let placemark = placemarks?.first
                
                let locationJson: [String: String] = [
                    "courtesies": placemark?.administrativeArea ?? "",
                    "delineated": placemark?.isoCountryCode ?? "",
                    "spoken": placemark?.country ?? "",
                    "particulars": placemark?.thoroughfare ?? "",
                    "fever": placemark?.locality ?? "",
                    "allayed": placemark?.subLocality ?? "",
                    "communicated": String(format: "%.6f", location.coordinate.latitude),
                    "palate": String(format: "%.6f", location.coordinate.longitude),
                ]
                
                self.finish(locationJson)
            }
        }
        
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + debounceInterval,
            execute: workItem
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        finish(nil)
    }
}
