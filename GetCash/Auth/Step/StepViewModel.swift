//
//  StepViewModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

import Foundation

class StepViewModel {
    
    /// product_detail_info
    func setpInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/broke",
                parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// face_detail_info
    func getFaceInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/breathe",
                parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// upload_id_info
    func uploadIDInfo(json: [String: String], imageData: Data) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/cottager",
                parameters: json,
                imageData: imageData)
            return model
        } catch {
            throw error
        }
    }
    
    /// save_id_info
    func savePhotoIDInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/aether",
                parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// apply_order_info
    func applyOrderIDInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/unclouded",
                parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}
