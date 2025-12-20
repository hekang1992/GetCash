//
//  StepViewModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import Foundation

class StepViewModel {
    
    func setpInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/broke", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    
}
