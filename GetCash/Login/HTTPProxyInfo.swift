//
//  HTTPProxyInfo.swift
//  GetCash
//
//  Created by hekang on 2025/12/24.
//

import Foundation

struct HTTPProxyInfo {

    enum ConnectionStatus: Int {
        case inactive = 0
        case active = 1
    }

    private static var proxySettings: [String: Any]? {
        CFNetworkCopySystemProxySettings()?
            .takeRetainedValue() as? [String: Any]
    }

    static var proxyStatus: ConnectionStatus {
        guard let settings = proxySettings else {
            return .inactive
        }

        let proxyKeys = ["HTTPProxy", "HTTPSProxy"]

        let isEnabled = proxyKeys.contains {
            !(settings[$0] as? String ?? "").isEmpty
        }

        return isEnabled ? .active : .inactive
    }

    static var vpnStatus: ConnectionStatus {
        guard
            let settings = proxySettings,
            let scoped = settings["__SCOPED__"] as? [String: Any]
        else {
            return .inactive
        }

        let vpnIdentifiers = ["tap", "tun", "ppp", "ipsec", "utun"]

        let isVPNActive = scoped.keys.contains { key in
            vpnIdentifiers.contains { key.localizedCaseInsensitiveContains($0) }
        }

        return isVPNActive ? .active : .inactive
    }
}

