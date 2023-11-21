//
//  ProfileFriendViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 18.11.2023.
//

import UIKit

class ProfileFriendViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var subscribers: UILabel!
    @IBOutlet weak var subscribe: UILabel!
    
    var user = AppUser(id: "", email: "", name: "", lastName: "", male: "", growth: "", weight: "", urlImage: "",following: [], followers: [])
    var currentUser = AppUser(id: "", email: "", name: "", lastName: "", male: "", growth: "", weight: "", urlImage: "",following: [], followers: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = user.name
        lastName.text = user.lastName
        subscribers.text = String(user.followers.count)
        

    }

    @IBAction func subscribeButton(_ sender: UIButton) {
        user.followers.append(currentUser.id)
        currentUser.following.append(user.id)
        
        DatabaseService.shared.setProfile(user: user) { resultUser in
            switch resultUser {
            case .success(let success):
                print(success.id)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }

        DatabaseService.shared.setProfile(user: currentUser) { resultCurrentUser in
            switch resultCurrentUser {
            case .success(let success):
                print(success.id)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }

    }
}
