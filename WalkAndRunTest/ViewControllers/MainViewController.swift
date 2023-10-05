//
//  MainViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import RealmSwift


class MainViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true


}
    
    @IBAction func showProfile(_ sender: UIButton) {
        
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(vc, animated: true)                


    }
    @IBAction func showNavigator( _ sender: UIButton) {
        

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NavigationViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
