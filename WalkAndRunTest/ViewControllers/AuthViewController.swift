//
//  AuthViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift

class AuthViewController: UIViewController, UIGestureRecognizerDelegate {
    var realmService = RealmService()
    var employee = [Employee]()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resetPasswordButton: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        realmService.deleteAllObjectsFromRealm()
        navigationItem.hidesBackButton = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        errorLable.alpha = 0
        activityIndicator.isHidden = true
        guard let _ = AuthService.shared.currentUser else { return }
        showMainVC()
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.errorLable.text = error!.localizedDescription
                self.errorLable.alpha = 1
            } else {
                self.showMainVC()
            }
            self.activityIndicator.isHidden = true
        }

        
        
    }
    @IBAction func registerButton(_ sender: UIButton) {
        showRegVC()
    }
    
    func showMainVC() {
        
        DatabaseService.shared.getProfile { user in
            switch user {

            case .success(let userDB):
                self.employee = self.realmService.localRealm.objects(Employee.self).filter({ $0.id == userDB.id })
                if let _ = self.employee.first {
                    print("Пользователь уже есть")
                } else {
                    let user = Employee()
                    user.id = userDB.id
                    user.email = userDB.email
                    user.name = userDB.name
                    user.lastName = userDB.lastName
                    user.male = userDB.name
                    user.growth = userDB.growth
                    user.weight = userDB.weight
                    do {
                        try? self.realmService.localRealm.write({
                            self.realmService.localRealm.add(user)
                         })
                            }
                    return
                    
                }
                

                

            case .failure(_):
                print("Нет пользователя в базе данных")
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showRegVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegViewController") as! RegViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapAction(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}
