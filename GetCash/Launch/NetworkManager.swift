//
//  NetworkManager.swift
//  GetCash
//
//  Created by hekang on 2025/12/24.
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
            switch status {
            case .unknown:
                statusBlock(.unknown)
            case .notReachable:
                statusBlock(.notReachable)
            case .reachable(.ethernetOrWiFi):
                statusBlock(.reachableViaWiFi)
            case .reachable(.cellular):
                statusBlock(.reachableViaCellular)
            }
        }
    }
    
    func stopListening() {
        reachabilityManager?.stopListening()
    }
}
