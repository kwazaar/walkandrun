//
//  SerchViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 18.11.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class SerchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serchBar: UISearchBar!
    
    var serchUser = AppUser(id: "", email: "", name: "", lastName: "", male: "", growth: "", weight: "", urlImage: "", subscribers: [])
    var resultUsers = [AppUser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    @IBAction func serchButton(_ sender: UIButton) {
        guard let email = serchBar.text else { return }
        
        DatabaseService.shared.getUsers(email: email) { result in
            switch result {
            case .success(let user):
                self.serchUser.id = user.id
                self.serchUser.name = user.name
                self.serchUser.lastName = user.lastName
                self.serchUser.urlImage = user.urlImage
                self.resultUsers.append(user)
                self.tableView.reloadData()
                
            case .failure(_):
                print("Такого пользователя не существует")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SerchProfileCell", for: indexPath) as! SerchProfileTableViewCell
        cell.name.text = serchUser.name
        cell.lastName.text = serchUser.lastName
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultUsers.count
    }
    
}
