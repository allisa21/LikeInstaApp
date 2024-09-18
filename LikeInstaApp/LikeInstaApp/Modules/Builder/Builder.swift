//
//  Builder.swift
//  LikeInstaApp
//
//  Created by Алла alla2104 on 12.09.24.
//

import UIKit

protocol BuilderProtocol {
    static func getPasscodeController(passcodeState: PasscodeState) -> UIViewController
    
}

final class Builder: BuilderProtocol {
    static func getPasscodeController(passcodeState: PasscodeState) -> UIViewController {
        let passcodeView = PasscodeView()
        let keychainManager = KeychainManager()
        let presenter = PasscodePresenter(view: passcodeView, passcodeState: .inputPasscode, keychainManager: keychainManager)
        
        passcodeView.passcodePresenter = presenter
        return passcodeView
    }
}
