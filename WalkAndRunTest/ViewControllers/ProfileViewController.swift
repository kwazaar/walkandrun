//
//  ProfileViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var employee = [Employee]()
    var realmService = RealmService()
    var routes = [RouteModel]()
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var male: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var growth: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
            employee = realmService.localRealm.objects(Employee.self).filter({ $0.email == AuthService.shared.currentUser?.email})
            guard let user = employee.first else { return }
            self.nameLable.text = user.name
            self.lastName.text = user.lastName
            self.male.text = user.male
            self.mail.text = user.email
            self.growth.text = user.growth
            self.weight.text = user.weight
        routes = realmService.localRealm.objects(RouteModel.self).filter({ $0.time > 0 })
        if routes.count < 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        
        
            
    }

 
    @IBAction func testPrintButton(_ sender: UIButton) {
        print(routes.first?.routeStep.first?.latitude, routes.first?.routeStep.first?.longitude)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        AuthService.shared.singOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell {
            let route = routes[indexPath.row]
            let region = MKCoordinateRegion(center: route.routeStep.first ?? CLLocationCoordinate2D(latitude: 55.755811, longitude: 37.617617), latitudinalMeters: 10000, longitudinalMeters: 10000)
            cell.mapView.setRegion(region, animated: true)
            cell.timeLable.text = String(route.time)
            cell.distanceLable.text = route.distance
            return cell
        }
            return CustomTableViewCell()
    }
}
