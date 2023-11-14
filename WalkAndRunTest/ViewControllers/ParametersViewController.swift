//
//  ParametersViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import RealmSwift

class ParametersViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var realmService = RealmService()
    var employee: Employee?
    
    var id = "" 
    var email = ""
    var male = ""
    var urlImage = "user"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var maleSegmentControl: UISegmentedControl!
    @IBOutlet weak var growtfTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var constraints: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        activetyKeyboardNotification()
        
        
    }
    
    @IBAction func choiseSecmented(_ sender: UISegmentedControl) {
        switch maleSegmentControl.selectedSegmentIndex {
        case 0:
            self.male = "Женский"
        case 1:
            self.male = "Мужской"
        default:
            self.male = "Не выбрано"
        }
    }
    
    @IBAction func sendParametersButton(_ sender: UIButton) {
        
        
        
        let endUser = AppUser(id: self.id,
                                    email: self.email,
                                    name: self.nameTextField.text!,
                                    lastName: self.lastNameTextField.text!,
                                    male: self.male,
                                    growth: growtfTextField.text!,
                                    weight: self.weightTextField.text!,
                                    urlImage: self.urlImage)
                                    
        if employee == nil {
            employee = Employee()
        }
        employee?.id = self.id
        employee?.name = self.nameTextField.text ?? ""
        employee?.lastName = self.lastNameTextField.text ?? ""
        employee?.email = self.email
        employee?.male = self.male
        employee?.growth = self.growtfTextField.text ?? ""
        employee?.weight = self.weightTextField.text ?? ""
        employee?.urlImage = self.urlImage
        
        guard let employee = employee else { return }
        
        try? realmService.localRealm.write {
            realmService.localRealm.add(employee)
        }
        

        DatabaseService.shared.setProfile(user: endUser, completion: { resultDB  in
            switch resultDB {
                
            case .success(_):
                print("User register")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "MainViewController") as! MainViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print( error.localizedDescription)
            }
            
        })
    }
    
    override func isPresentKeyboard(isOpen: Bool, height: CGFloat) {
        constraints.constant = -height / 5
                
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tapAction(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    


}
