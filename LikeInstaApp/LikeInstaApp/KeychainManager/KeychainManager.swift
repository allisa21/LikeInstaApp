//
//  KeychainManager.swift
//  LikeInstaApp
//
//  Created by Алла alla2104 on 17.09.24.
//

import Foundation
import KeychainAccess

protocol KeychainManagerProtocol: AnyObject {
    func save(key: String, value: String)
    func load(key: String) -> Result<String, Error>
}

class KeychainManager: KeychainManagerProtocol {
    
    private let keychain = Keychain(service: "PASSCODE")
    
    func save(key: String, value: String) {
        keychain[key] = value
    }
    
    func load(key: String) -> Result<String, any Error> {
        do {
            let passcode = try keychain.getString(key) ?? ""
            return .success(passcode)
        } catch {
            return .failure(error)
        }
    }
}

enum KeychainKeys: String {
    case passcode = "passcode1"
}
