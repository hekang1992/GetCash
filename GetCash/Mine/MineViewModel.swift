//
//  MineViewModel.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/23.
//

import Foundation

class MineViewModel {
    
    func mineCenterInfo() async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get(
                "/zyxwv/departed")
            return model
        } catch {
            ToastManager.showMessage(message: "Network Connection Error")
            throw error
        }
    }
    
    func deleteCenterInfo() async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get(
                "/zyxwv/courteous")
            return model
        } catch {
            ToastManager.showMessage(message: "Network Connection Error")
            throw error
        }
    }
    
    func logoutCenterInfo() async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get(
                "/zyxwv/forget")
            return model
        } catch {
            ToastManager.showMessage(message: "Network Connection Error")
            throw error
        }
    }
    
}
