//
//  DeviceConfig.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import Foundation
import AdSupport
import UIKit

class DeviceConfig {
    
    static func getIDFA() -> String {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if idfa == "00000000-0000-0000-0000-000000000000" {
            return ""
        }
        return idfa
    }
    
    static func getIDFV() -> String {
        if let existingIDFV = loadIDFVFromKeychain() {
            return existingIDFV
        }
        
        let idfv: String
        if let vendorId = UIDevice.current.identifierForVendor?.uuidString {
            idfv = vendorId
        } else {
            idfv = UUID().uuidString
        }
        
        saveIDFVToKeychain(idfv)
        return idfv
    }
    
    private static let keychainService = "com.getcash.app.idfv"
    private static let keychainAccount = "deviceIDFV"
    
    private static func saveIDFVToKeychain(_ idfv: String) {
        guard let data = idfv.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private static func loadIDFVFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let idfv = String(data: data, encoding: .utf8) {
            return idfv
        }
        
        return nil
    }
    
}
