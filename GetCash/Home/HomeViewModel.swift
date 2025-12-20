//
//  HomeViewModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import Foundation

class HomeViewModel {
    
    func homeInfo() async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/zyxwv/enwrapt")
            return model
        } catch {
            throw error
        }
    }
    
}
