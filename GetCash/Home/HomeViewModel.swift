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
            let model: BaseModel = try await HttpRequestManager.shared.get(
                "/zyxwv/enwrapt")
            return model
        } catch {
            ToastManager.showMessage(message: "Network Connection Error")
            throw error
        }
    }
    
    func enterInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/hint",
                parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func getAdressInfo() async throws -> BaseModel {
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get(
                "/zyxwv/indicated")
            return model
        } catch {
            throw error
        }
    }
    
}
