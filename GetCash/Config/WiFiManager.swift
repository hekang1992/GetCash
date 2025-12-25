//
//  WiFiManager.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/24.
//


import NetworkExtension
import Foundation

class WiFiManager {
    
    static func getWifiInfo(completion: @escaping ([String: Any]) -> Void) {
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent { hotspotNetwork in
                var wifiInfo: [String: Any] = [:]
                
                if let network = hotspotNetwork {
                    wifiInfo["debonnaire"] = network.bssid.lowercased()
                    wifiInfo["planet"] = network.ssid
                    completion(wifiInfo)
                } else {
                    completion([:])
                }
            }
        } else {
            completion([:])
        }
    }
}
