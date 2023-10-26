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
    var routeModel = [RouteModel]()
    var step = [Step]()
//    var realmImage = [ImageModel]()
    var arrayCoordinate = [CLLocationCoordinate2D]()
    
    var cooordinateRegion = CLLocation(latitude: 53.1, longitude: 33.2)
    
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
        
        routeModel = realmService.localRealm.objects(RouteModel.self).filter({ $0.time > 0 })
        guard let route = routeModel.last else { return }
        routeTime.text = String(route.time)
        for coordinate in route.route {
            arrayCoordinate.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        if routeModel.count < 0 {
//            tableView.isHidden = true
        } else {
//            tableView.isHidden = false
        }
        step = realmService.localRealm.objects(Step.self).filter({ $0.latitude > 0
        })
        
        
        
            
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayMapSnapshot()
    }
    
    func displayMapSnapshot() {
        if arrayCoordinate.isEmpty {
            print("Координат нет!")
        } else {
            let coordinates = arrayCoordinate
            
            // Находим минимальные и максимальные значения широты и долготы среди всех координат линии
            var minLat = coordinates[0].latitude
            var maxLat = coordinates[0].latitude
            var minLon = coordinates[0].longitude
            var maxLon = coordinates[0].longitude
            
            for coordinate in coordinates {
                minLat = min(minLat, coordinate.latitude)
                maxLat = max(maxLat, coordinate.latitude)
                minLon = min(minLon, coordinate.longitude)
                maxLon = max(maxLon, coordinate.longitude)
            }
            
            // Создаем регион, включающий в себя весь минимальный прямоугольник, окружающий линию
            let centerLat = (minLat + maxLat) / 2
            let centerLon = (minLon + maxLon) / 2
            let spanLat = (maxLat - minLat) * 1.1  // Добавляем 10% запаса по широте
            let spanLon = (maxLon - minLon) * 1.1  // Добавляем 10% запаса по долготе
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                                            span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon))
            
            let options = MKMapSnapshotter.Options()
            options.region = region
            options.size = routeImage.bounds.size
            options.scale = UIScreen.main.scale
            options.mapType = .standard
            
            let snapshoot = MKMapSnapshotter(options: options)
            snapshoot.start(with: .main) { [weak self] (snapshot, error) in
                guard let self = self else { return }
                guard error == nil, let snapshot = snapshot else { return }
                
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: .zero)
                
                if let context = UIGraphicsGetCurrentContext() {
                    let coordinates = arrayCoordinate
                    context.beginPath()
                    context.setLineWidth(5)
                    context.setStrokeColor(UIColor.orange.cgColor)
                    var started = false
                    for coordinate in coordinates {
                        let point = snapshot.point(for: coordinate)
                        if started {
                            context.addLine(to: point)
                        } else {
                            context.move(to: point)
                            started = true
                        }
                    }
                    
                    context.strokePath()
                }
                
                
                let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
                self.routeImage.image = drawnImage
                
            }
        }
    }
    
    func setRegion() {
        
    }

 
    @IBAction func testPrintButton(_ sender: UIButton) {
//        realmImage = realmService.localRealm.objects(ImageModel.self).filter({ $0.image != nil })
//        guard let imageData = realmImage.first?.image else { return }
//        print(imageData)
//        routeImage.image = UIImage(data: imageData)
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
