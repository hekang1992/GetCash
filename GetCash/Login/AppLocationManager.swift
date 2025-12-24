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
    
    private let userDefaults = UserDefaults.standard
    private let lastAlertDateKey = "AppLocationManager_lastAlertDate"
    
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
            showAlertIfNeeded()
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
    
    private func shouldShowAlert() -> Bool {
        if let lastDate = userDefaults.object(forKey: lastAlertDateKey) as? Date {
            if Calendar.current.isDateInToday(lastDate) {
                return false
            }
        }
        return true
    }
    
    private func updateLastAlertDate() {
        userDefaults.set(Date(), forKey: lastAlertDateKey)
        userDefaults.synchronize()
    }
    
    private func showAlertIfNeeded() {
        guard shouldShowAlert() else {
            return
        }
        
        DispatchQueue.main.async {
            guard let topViewController = self.getTopViewController() else { return }
            
            let alertController = UIAlertController(
                title: "位置权限被拒绝",
                message: "请在设置中开启位置权限，以便使用完整功能。您可以在\"设置\" > \"隐私\" > \"定位服务\"中重新开启。",
                preferredStyle: .alert
            )
            
            let settingsAction = UIAlertAction(title: "前往设置", style: .default) { _ in
                self.openAppSettings()
                self.updateLastAlertDate()
            }
            
            let cancelAction = UIAlertAction(title: "稍后再说", style: .cancel) { _ in
                self.updateLastAlertDate()
            }
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
    private func getTopViewController(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first?.rootViewController
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        
        return base
    }
}

// MARK: - CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
            
        case .denied, .restricted:
            let breathe = UserDefaults.standard.object(forKey: "breathe") as? String ?? ""
            if breathe == "1" {
                if LoginManager.isLoggedIn {
                    showAlertIfNeeded()
                }
            }
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
