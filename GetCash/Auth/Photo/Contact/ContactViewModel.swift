//
//  ContactViewModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/22.
//

import Foundation

class ContactViewModel {
    
    /// get_contact_info
    func getContactInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/mortal", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// save_contact_info
    func saveContactInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/unsphered", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// upload_contact_info
    func uploadContactInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/describe", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}
