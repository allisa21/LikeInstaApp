//
//  SceneDelegate.swift
//  LikeInstaApp
//
//  Created by Алла alla2104 on 12.09.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
private var keychainManager = KeychainManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = Builder.getPasscodeController(passcodeState: checkIsSet())
        window?.makeKeyAndVisible()
    }
    
    private func checkIsSet() -> PasscodeState {
        let keychainPasscodeResult = keychainManager.load(key: KeychainKeys.passcode.rawValue)
        switch keychainPasscodeResult {
        case .success(let code):
            return code.isEmpty ? .setNewPasscode : .inputPasscode
        case .failure(let error):
            return .setNewPasscode
        }
    }
}

