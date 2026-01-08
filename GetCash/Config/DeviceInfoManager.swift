//
//  DeviceInfoManager.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/24.
//

import UIKit
import SystemConfiguration
import CoreTelephony
import Foundation
import SystemConfiguration.CaptiveNetwork

class DeviceInfoManager {
    
    static func getStorageInfo() -> [String: String] {
        var storageInfo: [String: String] = [:]
        let getMemoryInfo = getMemoryInfo()
        do {
            let fileManager = FileManager.default
            let homeDirectory = URL(fileURLWithPath: NSHomeDirectory())
            
            let resourceValues = try homeDirectory.resourceValues(forKeys: [
                .volumeTotalCapacityKey,
                .volumeAvailableCapacityKey,
                .volumeAvailableCapacityForImportantUsageKey
            ])
            
            let systemAttributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            
            if let totalBytes = resourceValues.volumeTotalCapacity {
                storageInfo["inner"] = String(totalBytes)
            } else if let totalSize = systemAttributes[.systemSize] as? UInt64 {
                storageInfo["inner"] = String(totalSize)
            }
            
            if let availableBytes = resourceValues.volumeAvailableCapacity {
                storageInfo["illuminated"] = String(availableBytes)
            } else if let freeSize = systemAttributes[.systemFreeSize] as? UInt64 {
                storageInfo["illuminated"] = String(freeSize)
            }
            storageInfo["conductor"] = getMemoryInfo["conductor"]
            storageInfo["preference"] = getMemoryInfo["preference"]
            
        } catch {
            
        }
        
        return storageInfo
    }
    
    static func getMemoryInfo() -> [String: String] {
        var memoryInfo: [String: String] = [:]
        
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        memoryInfo["conductor"] = "\(totalMemory)"
        
        var hostSize = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
        var hostInfo = vm_statistics_data_t()
        let hostPort = mach_host_self()
        
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(hostSize)) {
                host_statistics(hostPort, HOST_VM_INFO, $0, &hostSize)
            }
        }
        
        if result == KERN_SUCCESS {
            let pageSize = vm_kernel_page_size
            let freeMemory = UInt64(hostInfo.free_count) * UInt64(pageSize)
            let activeMemory = UInt64(hostInfo.active_count) * UInt64(pageSize)
            let inactiveMemory = UInt64(hostInfo.inactive_count) * UInt64(pageSize)
            let wireMemory = UInt64(hostInfo.wire_count) * UInt64(pageSize)
            
            let usedMemory = activeMemory + inactiveMemory + wireMemory
            let availableMemory = totalMemory - usedMemory
            
            memoryInfo["preference"] = "\(availableMemory)"
        } else {
            memoryInfo["preference"] = "0"
        }
        
        return memoryInfo
    }
    
    static func getBatteryInfo() -> [String: Int] {
        var batteryInfo: [String: Int] = [:]
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        batteryInfo["grapes"] = batteryLevel
        
        let isCharging = UIDevice.current.batteryState == .charging ||
        UIDevice.current.batteryState == .full ? 1 : 0
        batteryInfo["baskets"] = isCharging
        
        return batteryInfo
    }
    
    static func getDeviceInfo() -> [String: String] {
        var deviceInfo: [String: String] = [:]
        
        deviceInfo["across"] = UIDevice.current.systemVersion
        deviceInfo["curiosity"] = UIDevice.current.name
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        deviceInfo["eager"] = identifier
        
        return deviceInfo
    }
    
    static func getSecurityInfo() -> [String: Int] {
        var securityInfo: [String: Int] = [:]
        
#if targetEnvironment(simulator)
        securityInfo["peasantry"] = 1
#else
        securityInfo["peasantry"] = 0
#endif
        
        securityInfo["sequestered"] = DeviceInfoManager.isJailbroken() ? 1 : 0
        
        return securityInfo
    }
    
    static func getSystemInfo() -> [String: String] {
        var systemInfo: [String: String] = [:]
        
        systemInfo["heighten"] = NSTimeZone.system.abbreviation() ?? ""
        
        systemInfo["table"] = DeviceConfig.getIDFV()
        
        systemInfo["lateness"] = Locale.preferredLanguages.first ?? "en"
        
        systemInfo["comparison"] = UserDefaults.standard.object(forKey: "net_work_type") as? String ?? ""
        
        systemInfo["insisted"] = DeviceConfig.getIDFA()
        
        return systemInfo
    }
    
    private static func isJailbroken() -> Bool {
        let jailbreakFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]
        
        for path in jailbreakFilePaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile: "/private/jailbreak.txt",
                                    atomically: true,
                                    encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    static func getAllDeviceInfoWithDispatchGroup(completion: @escaping ([String: Any]) -> Void) {
        var allInfo: [String: Any] = [:]
        let dispatchGroup = DispatchGroup()
        
        allInfo["rejoicing"] = getStorageInfo()
        allInfo["contention"] = getBatteryInfo()
        allInfo["wine"] = getDeviceInfo()
        allInfo["flocked"] = getSecurityInfo()
        allInfo["phenomenon"] = getSystemInfo()
        
        dispatchGroup.enter()
        WiFiManager.getWifiInfo { wifiInfo in
            allInfo["awakening"] = ["joy": wifiInfo]
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(allInfo)
        }
    }
    
}
