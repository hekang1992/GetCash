//
//  OrderViewModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/23.
//

import Foundation

class OrderViewModel {
    
    func orderListInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/zyxwv/numbered", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}
