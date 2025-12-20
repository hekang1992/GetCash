//
//  LoginViewModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import Foundation

class LoginViewModel {
    
    func codeInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/recollect", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func voiceCodeInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/strongly", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func loginInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/hoping", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}
