//
//  PasscodePresenter.swift
//  LikeInstaApp
//
//  Created by Алла alla2104 on 12.09.24.
//

import UIKit

protocol PasscodePresenterProtocol: AnyObject {
    var passcode: [Int] { get set }
    var templatePasscode: [Int]? { get set}
    
    func enterPasscode(number: Int)
    func removeLastItemInPasscode()
    func setNewPasscode()
    func checkPasscode()
    func clearPasscode(state: PasscodeState)
    
    init(view: PasscodeViewProtocol, passcodeState: PasscodeState, keychainManager: KeychainManagerProtocol)
}

final class PasscodePresenter: PasscodePresenterProtocol {
    var templatePasscode: [Int]?
    var passcode: [Int] = [] {
        didSet {
            if passcode.count == 4 {
                switch passcodeState {
                case .inputPasscode:
                    self .checkPasscode()
                case .setNewPasscode:
                    self.setNewPasscode()
                default:
                    break
                }
            }
        }
    }
    
    var view: PasscodeViewProtocol
    var passcodeState: PasscodeState
    var keychainManager: KeychainManagerProtocol
    
    required init(view: PasscodeViewProtocol, passcodeState: PasscodeState, keychainManager: KeychainManagerProtocol) {
        self.view = view
        self.passcodeState = passcodeState
        self.keychainManager = keychainManager
        
        view.passcodeState(state: passcodeState)
        
    }
    
    func enterPasscode(number: Int) {
        if passcode.count < 4 {
            self.passcode.append(number)
            view.enterCode(code: passcode)
        }
    }
    
    func removeLastItemInPasscode() {
        if !passcode.isEmpty {
            self.passcode.removeLast()
            view.enterCode(code: passcode)
        }
    }
    
    func setNewPasscode() {
        if templatePasscode != nil {
            if passcode == templatePasscode! {
                let stringPasscode = passcode.map{ String($0) }.joined()
                keychainManager.save(key: KeychainKeys.passcode.rawValue, value: stringPasscode)
             
                print("saved!")
            } else {
                self.view.passcodeState(state: .codeMissMatch)
            }
        } else {
            templatePasscode = passcode
            self.clearPasscode(state: .repeatPasscode)
        }
    }
    
    func checkPasscode() {
        let keychainPasscodeResult = keychainManager.load(key: KeychainKeys.passcode.rawValue)
        switch keychainPasscodeResult {
        case .success(let code):
            if self.passcode == code.digits {
                print("success")
            } else {
                self.clearPasscode(state: .wrongPasscode)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func clearPasscode(state: PasscodeState) {
        self.passcode = []
        self.view.enterCode(code: [])
        view.passcodeState(state: state)
    }
    
    
    
    
}

enum PasscodeState: String {
    case inputPasscode, wrongPasscode, setNewPasscode, repeatPasscode, codeMissMatch
    
    func getPasscodeLabel() -> String {
        switch self {
        case .inputPasscode:
            return "Введите код"
        case .wrongPasscode:
            return "Неверный код"
        case .setNewPasscode:
            return "Установить код"
        case .repeatPasscode:
            return "Повторите код"
        case .codeMissMatch:
            return "Коды не совпадают"
        }
    }
}
