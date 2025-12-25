//
//  ImagePickerHelper.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/21.
//

import UIKit
import Photos
import AVFoundation

class ImagePickerHelper: NSObject {
    
    typealias ImagePickerCompletion = (UIImage?) -> Void
    
    private static var currentCompletion: ImagePickerCompletion?
    private static weak var currentViewController: UIViewController?
    
    class func takePhoto(from viewController: UIViewController, isFront: Bool, completion: @escaping ImagePickerCompletion) {
        currentViewController = viewController
        currentCompletion = completion
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .authorized:
            openCamera(isFront: isFront)
        case .denied, .restricted:
            showPermissionAlert(message: "需要相机权限来拍摄照片，请在设置中开启权限")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        openCamera(isFront: isFront)
                    } else {
                        showPermissionAlert(message: "需要相机权限来拍摄照片，请在设置中开启权限")
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    class func pickPhoto(from viewController: UIViewController, completion: @escaping ImagePickerCompletion) {
        currentViewController = viewController
        currentCompletion = completion
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authStatus {
        case .authorized, .limited:
            openPhotoLibrary()
        case .denied, .restricted:
            showPermissionAlert(message: "需要相册权限来选择照片，请在设置中开启权限")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        openPhotoLibrary()
                    } else {
                        showPermissionAlert(message: "需要相册权限来选择照片，请在设置中开启权限")
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    private class func openCamera(isFront: Bool) {
        guard let vc = currentViewController else { return }
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = sharedInstance
        picker.allowsEditing = false
        picker.cameraDevice = isFront ? .front : .rear
        vc.present(picker, animated: true)
    }
    
    private class func openPhotoLibrary() {
        guard let vc = currentViewController else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = sharedInstance
        picker.allowsEditing = false
        vc.present(picker, animated: true)
    }
    
    private class func showPermissionAlert(message: String) {
        guard let vc = currentViewController else { return }
        
        let alert = UIAlertController(
            title: "权限提示",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
            openAppSettings()
        }))
        
        vc.present(alert, animated: true)
    }
    
    private class func showAlert(title: String, message: String) {
        guard let vc = currentViewController else { return }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    private class func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsURL) else {
            return
        }
        
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    private class func compressImage(_ image: UIImage, maxKB: Double = 800) -> UIImage? {
        var compression: CGFloat = 1.0
        let maxLength = maxKB * 1024
        
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return image
        }
        
        if Double(imageData.count) <= maxLength {
            return UIImage(data: imageData)
        }
        
        var max: CGFloat = 1.0
        var min: CGFloat = 0.0
        
        for _ in 0..<6 {
            compression = (max + min) / 2
            if let data = image.jpegData(compressionQuality: compression) {
                imageData = data
                if Double(imageData.count) <= maxLength * 0.7 {
                    min = compression
                } else if Double(imageData.count) > maxLength {
                    max = compression
                } else {
                    break
                }
            } else {
                break
            }
        }
        
        if Double(imageData.count) > maxLength {
            let ratio = sqrt(maxLength / Double(imageData.count))
            let newSize = CGSize(
                width: image.size.width * ratio,
                height: image.size.height * ratio
            )
            
            UIGraphicsBeginImageContext(newSize)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        return UIImage(data: imageData)
    }
    
    private static let sharedInstance = ImagePickerHelper()
    
    private override init() {
        super.init()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            guard let originalImage = info[.originalImage] as? UIImage else {
                Self.currentCompletion?(nil)
                Self.cleanup()
                return
            }
            
            let compressedImage = Self.compressImage(originalImage, maxKB: 800)
            Self.currentCompletion?(compressedImage)
            Self.cleanup()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            Self.currentCompletion?(nil)
            Self.cleanup()
        }
    }
    
    private class func cleanup() {
        currentCompletion = nil
        currentViewController = nil
    }
}
