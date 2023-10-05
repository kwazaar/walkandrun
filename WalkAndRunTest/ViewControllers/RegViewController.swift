//
//  RegViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class RegViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLable.alpha = 0
        activityIndicator.hidesWhenStopped = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        if isValidTextField() != nil {
            self.errorLable.text = isValidTextField()
            self.errorLable.alpha = 1
            activityIndicator.isHidden = true
        } else {
            guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
            Auth.auth().createUser(withEmail: email , password: password) { result, error in
                if let result = result {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "ParametersViewController") as! ParametersViewController
                    vc.id = result.user.uid
                    vc.email = result.user.email!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if let error = error {
                    self.errorLable.text = error.localizedDescription
                    self.errorLable.alpha = 1
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    func isValidTextField() -> String? {
        if emailTextField.text! == "",
           passwordTextField.text! == "",
           repeatPasswordTextField.text! == ""{
            print("Незаполненные поля")
            return "Незаполненные поля"
        } else if passwordTextField.text! != repeatPasswordTextField.text! {
            print("Пароли не совпадают")
            return "Пароли не совпадают"
        }
        
        return nil
    }
    @objc func tapAction(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
}
