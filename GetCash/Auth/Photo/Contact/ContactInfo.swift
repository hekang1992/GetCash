//
//  ContactInfo.swift
//  GetCash
//
//  Created by hekang on 2025/12/22.
//


import UIKit
import Contacts
import ContactsUI

struct ContactInfo: Codable {
    var planet: String
    var stars: String
    
    enum CodingKeys: String, CodingKey {
        case planet, stars
    }
}

typealias ContactSelectionHandler = (String?, Error?) -> Void
typealias AllContactsHandler = (String?, Error?) -> Void
typealias AuthorizationHandler = (Bool) -> Void

class ContactManager: NSObject {
    
    private let contactStore = CNContactStore()
    private var currentViewController: UIViewController?
    private var selectionHandler: ContactSelectionHandler?
    private var allContactsHandler: AllContactsHandler?
    
    func checkAuthorization(completion: @escaping AuthorizationHandler) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            requestAuthorization(completion: completion)
        case .denied, .restricted:
            showPermissionAlert()
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func requestAuthorization(completion: @escaping AuthorizationHandler) {
        contactStore.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false)
                } else {
                    completion(granted)
                }
            }
        }
    }
    
    private func showPermissionAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "无法访问联系人",
                message: "请在设置中开启联系人访问权限",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            
            self.currentViewController?.present(alert, animated: true)
        }
    }
    
    func openContactPicker(from viewController: UIViewController, completion: @escaping ContactSelectionHandler) {
        self.selectionHandler = completion
        
        checkAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                DispatchQueue.main.async {
                    let picker = CNContactPickerViewController()
                    picker.delegate = self
                    picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
                    picker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                    
                    self.currentViewController = viewController
                    viewController.present(picker, animated: true)
                }
            } else {
                let error = NSError(domain: "ContactManager", code: 1000, userInfo: [NSLocalizedDescriptionKey: "error"])
                completion(nil, error)
            }
        }
    }
    
    func fetchAllContacts(completion: @escaping AllContactsHandler) {
        self.allContactsHandler = completion
        
        checkAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let contacts = try self.fetchContactsFromStore()
                        if let jsonString = self.contactsToJSON(contacts: contacts) {
                            DispatchQueue.main.async {
                                completion(jsonString, nil)
                            }
                        } else {
                            let error = NSError(domain: "ContactManager", code: 1001, userInfo: [NSLocalizedDescriptionKey: "JSON_ERROR"])
                            DispatchQueue.main.async {
                                completion(nil, error)
                            }
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
            } else {
                let error = NSError(domain: "ContactManager", code: 1000, userInfo: [NSLocalizedDescriptionKey: "error"])
                completion(nil, error)
            }
        }
    }
    
    private func fetchContactsFromStore() throws -> [ContactInfo] {
        var contacts: [ContactInfo] = []
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        request.sortOrder = .givenName
        
        try contactStore.enumerateContacts(with: request) { contact, stop in
            if !contact.phoneNumbers.isEmpty {
                let phoneNumbers = contact.phoneNumbers.map { self.cleanPhoneNumber($0.value.stringValue) }
                let stars = phoneNumbers.joined(separator: ",")
                
                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                let contactInfo = ContactInfo(planet: name, stars: stars)
                contacts.append(contactInfo)
            }
        }
        
        return contacts
    }
    
    private func cleanPhoneNumber(_ phoneNumber: String) -> String {
        let cleaned = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return cleaned
    }
    
    private func contactsToJSON(contacts: [ContactInfo]) -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            let jsonData = try encoder.encode(contacts)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    func cleanup() {
        selectionHandler = nil
        allContactsHandler = nil
        currentViewController = nil
    }
}

// MARK: - CNContactPickerViewControllerDelegate
extension ContactManager: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumbers = contact.phoneNumbers.map { self.cleanPhoneNumber($0.value.stringValue) }
        let stars = phoneNumbers.joined(separator: ",")
        
        let planet = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
        
        let contactInfo = ContactInfo(planet: planet, stars: stars)
        
        if let jsonString = contactsToJSON(contacts: [contactInfo]) {
            selectionHandler?(jsonString, nil)
        } else {
            let error = NSError(domain: "ContactManager", code: 1001, userInfo: [NSLocalizedDescriptionKey: "JSON_ERROR"])
            selectionHandler?(nil, error)
        }
        
        selectionHandler = nil
        picker.dismiss(animated: true)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        selectionHandler?(nil, nil)
        selectionHandler = nil
        picker.dismiss(animated: true)
    }
}

