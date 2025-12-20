//
//  CommonParaManager.swift
//  GetCash
//
//  Created by hekang on 2025/12/19.
//

import UIKit
import Foundation

class CommonParameterManager {
    
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let deviceName = UIDevice.current.name
    static let idfv = DeviceConfig.getIDFV()
    static let systemVersion = UIDevice.current.systemVersion
    static let authToken = LoginManager.currentToken
//    static let idfa = DeviceConfig.getIDFA()
    static let idfa = "4315431-43113-431413"
    
    struct DeviceInfo {
        let appVersion: String
        let deviceName: String
        let idfv: String
        let systemVersion: String
        let authToken: String
        let idfa: String
        
        init() {
            self.appVersion = CommonParameterManager.appVersion
            self.deviceName = CommonParameterManager.deviceName
            self.idfv = CommonParameterManager.idfv
            self.systemVersion = CommonParameterManager.systemVersion
            self.authToken = LoginManager.currentToken
            self.idfa = CommonParameterManager.idfa
        }
        
        func toAPIDictionary() -> [String: String] {
            return [
                "please": appVersion,
                "liable": deviceName,
                "gloominess": idfv,
                "startled": systemVersion,
                "extreme": authToken,
                "reluctance": idfa
            ]
        }
    }
    
    static let shared = CommonParameterManager()
    private init() {}
    
    static func getAPIParameters() -> [String: String] {
        return DeviceInfo().toAPIDictionary()
    }
    
}

