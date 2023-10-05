//
//  NavigationViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 05.10.2023.
//

import UIKit
import MapKit


class NavigationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        checkLocationEnabled()
    }
    
    func checkLocationEnabled() {
//        DispatchQueue.global().async {
//            if CLLocationManager.locationServicesEnabled() {
//                self.setupManager()
//            } else {
//                let alert = UIAlertController(title: "У вас выключена служба геолокации", message: "Включите службу для корректного отображения", preferredStyle: .alert)
//                let settingAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
//                    if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
//                        UIApplication.shared.open(url)
//                    }
//                    
//                }
//                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//                
//                alert.addAction(settingAction)
//                alert.addAction(cancelAction)
//                
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
        
    }
    
    func setupManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }

}
