//
//  ProfileViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var employee = [Employee]()
    var realmService = RealmService()
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var male: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var growth: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            employee = realmService.localRealm.objects(Employee.self).filter({ $0.email == AuthService.shared.currentUser?.email})
            guard let user = employee.first else { return }
            self.nameLable.text = user.name
            self.lastName.text = user.lastName
            self.male.text = user.male
            self.mail.text = user.email
            self.growth.text = user.growth
            self.weight.text = user.weight

    }

    
    @IBAction func logOut(_ sender: UIButton) {
        AuthService.shared.singOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
