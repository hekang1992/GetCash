//
//  LoginManager.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
//

import Foundation

class LoginManager {
    
    private enum Keys {
        static let userPhone = "user_phone"
        static let userToken = "user_token"
    }
    
    static func saveLogin(phone: String, token: String) {
        UserDefaults.standard.set(phone, forKey: Keys.userPhone)
        UserDefaults.standard.set(token, forKey: Keys.userToken)
        UserDefaults.standard.synchronize()
    }
    
    static func clearLogin() {
        UserDefaults.standard.removeObject(forKey: Keys.userPhone)
        UserDefaults.standard.removeObject(forKey: Keys.userToken)
        UserDefaults.standard.synchronize()
    }
    
    static var isLoggedIn: Bool {
        return !currentPhone.isEmpty && !currentToken.isEmpty
    }
    
    static var currentPhone: String {
        return UserDefaults.standard.string(forKey: Keys.userPhone) ?? ""
    }
    
    static var currentToken: String {
        return UserDefaults.standard.string(forKey: Keys.userToken) ?? ""
    }
    
}
