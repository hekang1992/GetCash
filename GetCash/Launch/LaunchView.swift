//
//  LaunchView.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/19.
//

import UIKit
import SnapKit

class LaunchView: BaseView {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "start_page")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// launch_view_model
class LaunchViewModel {
    
    func appInitInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/lateness",
                parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func uploadIDInfo(json: [String: String]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/settled",
                parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}

/// track_view_model
class AppTrackViewModel {
    
    func trackMessageInfo(json: [String: String]) async throws -> BaseModel {
        
        var apiJson = [
            "fruits": "2",
            "voisin": DeviceConfig.getIDFV(),
            "honeysuckles": DeviceConfig.getIDFA()
        ]
        
        apiJson.merge(json) { (_, new) in new }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm(
                "/zyxwv/acknowledge",
                parameters: apiJson)
            return model
        } catch {
            throw error
        }
    }
    
}
