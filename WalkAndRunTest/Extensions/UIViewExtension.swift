//
//  File.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 04.10.2023.
//

import UIKit
extension UIViewController {
    
    func activetyKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: NSNotification.Name(UIResponder.keyboardWillShowNotification.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: NSNotification.Name(UIResponder.keyboardWillHideNotification.rawValue), object: nil)
    }
    
    @objc private func keyboardWillShowNotification(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let nsValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let height = nsValue.cgRectValue.height as CGFloat
        isPresentKeyboard(isOpen: true, height: height)

    }
    
    @objc private func keyboardWillHideNotification(_ notification: NSNotification) {
        isPresentKeyboard(isOpen: false, height: 0)
    }
    
    @objc func isPresentKeyboard(isOpen: Bool, height: CGFloat) {
        
    }
}
