//
//  PersonalViewModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import Foundation

class PersonalViewModel {
    
    /// personal_detail_info
    func getPersonalInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/boundless", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// save_personal_detail_info
    func savePersonalInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/mould", parameters: json)
            return model
        } catch {
            throw error
        }
    }
}
