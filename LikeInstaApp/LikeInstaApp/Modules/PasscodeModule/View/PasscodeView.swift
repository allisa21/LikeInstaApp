//
//  PasscodeView.swift
//  LikeInstaApp
//
//  Created by Алла alla2104 on 12.09.24.
//

import UIKit

protocol PasscodeViewProtocol: AnyObject {
    func passcodeState(state: PasscodeState)
    func enterCode(code: [Int])
}

final class PasscodeView: UIViewController {
    
    var passcodePresenter: PasscodePresenterProtocol!
    
    private let buttons: [ [Int] ] = [[1,2,3], [4,5,6], [7,8,9], [0]]
    
    private lazy var passcodeTitle: UILabel = {
        .configure(view: $0) { label in
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textAlignment = .center
        }
    }(UILabel())
    
    private lazy var keyboardStack: UIStackView = {
        .configure(view: $0) { stack in
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            stack.alignment = .center
        }
    }(UIStackView())
    
    private lazy var codeStack: UIStackView = {
        .configure(view: $0) { stack in
            stack.axis = .horizontal
            stack.distribution = .equalCentering
            stack.spacing = 20
        }
    }(UIStackView())
    
    lazy var deleteButton: UIButton = {
        .configure(view: $0) { button in
            button.widthAnchor.constraint(equalToConstant: 65).isActive = true
            button.heightAnchor.constraint(equalToConstant: 65).isActive = true
            button.setImage(UIImage(systemName: "delete.backward"), for: .normal)
            button.tintColor = UIColor.white
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 45), forImageIn: .normal)
     
        }
    }(UIButton(primaryAction: deleteCodeAction))
    
    lazy var enterCodeAction = UIAction { [weak self ] sender in
        guard let self = self,
        let sender = sender.sender as? UIButton
        else { return }
        
        self.passcodePresenter.enterPasscode(number: sender.tag)
    }
    
    lazy var deleteCodeAction = UIAction { [weak self ] sender in
        guard let self = self,
        let sender = sender.sender as? UIButton
        else { return }
        
        self.passcodePresenter.removeLastItemInPasscode()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appMain
        
        [keyboardStack, passcodeTitle, codeStack, deleteButton].forEach{
            view.addSubview($0)
        }
        
        buttons.forEach {
            let buttonLine = setHorizontalStack(range: $0)
            keyboardStack.addArrangedSubview(buttonLine)
        }
        
        (11...14).forEach {
            let view = getCodeView(tag: $0)
            codeStack.addArrangedSubview(view)
        }
        
        NSLayoutConstraint.activate([
            
            passcodeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passcodeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passcodeTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            passcodeTitle.heightAnchor.constraint(equalToConstant: 50),
            
            codeStack.topAnchor.constraint(equalTo: passcodeTitle.bottomAnchor, constant: 50),
            codeStack.widthAnchor.constraint(equalToConstant: 140),
            codeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            keyboardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            keyboardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            keyboardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyboardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            
            deleteButton.rightAnchor.constraint(equalTo: keyboardStack.rightAnchor, constant: -25),
            deleteButton.bottomAnchor.constraint(equalTo: keyboardStack.bottomAnchor, constant: -5)
        ])
    }


}

extension PasscodeView {
    private func getHorizontalNumStack() -> UIStackView {
        return {
            .configure(view: $0) { stack in
                stack.axis = .horizontal
                stack.spacing = 50
            }
        }(UIStackView())
    }
    
    private func setHorizontalStack(range: [Int]) -> UIStackView {
        let stack = getHorizontalNumStack()
        range.forEach {
            let numButton = UIButton(primaryAction: enterCodeAction)
            numButton.tag = $0
            numButton.setTitle("\($0)", for: .normal)
            numButton.setTitleColor(.white, for: .normal)
            numButton.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .light)
            numButton.widthAnchor.constraint(equalToConstant: 60)
            stack.addArrangedSubview(numButton)
        }
        return stack
    }
    
    private func getCodeView(tag: Int) -> UIView {
        return {
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 2
            $0.tag = tag
            $0.layer.borderColor = UIColor.white.cgColor
            return $0
        }(UIView())
    }
}

extension PasscodeView: PasscodeViewProtocol {
    
    func passcodeState(state: PasscodeState) {
        passcodeTitle.text = state.getPasscodeLabel()
    }
    
    func enterCode(code: [Int]) {
        let tag = code.count + 10
        (tag...14).forEach {
            view.viewWithTag($0)?.backgroundColor = .none
        }
        view.viewWithTag(tag)?.backgroundColor = .white
    }
    
    
}
