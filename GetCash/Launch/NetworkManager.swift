//
//  NetworkManager.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/24.
//

import Alamofire

enum NetworkStatus {
    case unknown
    case notReachable
    case reachableViaWiFi
    case reachableViaCellular
}

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    private init() {}
    
    func startListening(statusBlock: @escaping (NetworkStatus) -> Void) {
        
        reachabilityManager?.startListening { status in
            var type: String = "OTHER"
            switch status {
            case .unknown:
                statusBlock(.unknown)
                type = "unknown"
            case .notReachable:
                statusBlock(.notReachable)
                type = "OTHER"
            case .reachable(.ethernetOrWiFi):
                statusBlock(.reachableViaWiFi)
                type = "WIFI"
            case .reachable(.cellular):
                statusBlock(.reachableViaCellular)
                type = "5G"
            }
            UserDefaults.standard.set(type, forKey: "net_work_type")
            UserDefaults.standard.synchronize()
        }
    }
    
    func stopListening() {
        reachabilityManager?.stopListening()
    }
}
