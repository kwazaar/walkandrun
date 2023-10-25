//
//  ProfileViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController, MKMapViewDelegate { //, UITableViewDataSource, UITableViewDelegate
    
    var employee = [Employee]()
    var realmService = RealmService()
    var routes = [RouteModel]()
    var step = [Step]()
    var realmImage = [ImageModel]()
    var arrayCoordinate = [CLLocationCoordinate2D]()
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var male: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var growth: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    
    
    @IBOutlet weak var routeImage: UIImageView!
    @IBOutlet weak var routeTime: UILabel!
    //    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.reloadData()
        
            employee = realmService.localRealm.objects(Employee.self).filter({ $0.email == AuthService.shared.currentUser?.email})
            guard let user = employee.first else { return }
            self.nameLable.text = user.name
            self.lastName.text = user.lastName
            self.male.text = user.male
            self.mail.text = user.email
            self.growth.text = user.growth
            self.weight.text = user.weight
        routes = realmService.localRealm.objects(RouteModel.self).filter({ $0.time > 0 })
        guard let route = routes.first else { return }
        routeTime.text = String(route.time)
        if let image = UIImage(data: route.image) {
            self.imagePhoto = UIImageView(image: image)
        } else {
            print("No image")
        }
        
        if routes.count < 0 {
//            tableView.isHidden = true
        } else {
//            tableView.isHidden = false
        }
        step = realmService.localRealm.objects(Step.self).filter({ $0.latitude > 0
        })
        
        
        
            
    }

 
    @IBAction func testPrintButton(_ sender: UIButton) {
        realmImage = realmService.localRealm.objects(ImageModel.self).filter({ $0.image != nil })
        guard let imageData = realmImage.first?.image else { return }
        print(imageData)
        routeImage.image = UIImage(data: imageData)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        AuthService.shared.singOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return routes.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell {
//            let route = routes[indexPath.row]
//            cell.timeLable.text = String(route.time)
//            cell.distanceLable.text = route.distance
//
//            if let image = UIImage(data: route.image) {
//                cell.imageRoute.image = image
//            } else {
//                cell.imageRoute.image = UIImage(named: "Image")
//            }
//
//            return cell
//        }
//            return CustomTableViewCell()
//    }


    
}
