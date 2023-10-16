//
//  NavigationViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 05.10.2023.
//

import UIKit
import MapKit


class NavigationViewController: UIViewController, CLLocationManagerDelegate {

//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var serchTextField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
////        checkLocationEnabled()
////        checkAutorization()
//    }
//
//    @IBAction func serchButton(_ sender: UIButton) {
//      print("serch")
//    }
//    func checkLocationEnabled() {
//        DispatchQueue.global().async {
//            if CLLocationManager.locationServicesEnabled() {
//                self.setupManager()
//
//            } else {
//                self.showAlertMassage(title: "Перейдите в настойки и включите геолокацию", massage: "Перейти", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
//            }
//        }
//
//    }
//
//    func setupManager() {
//
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//    }
//
//    func checkAutorization() {
//
//        switch locationManager.authorizationStatus {
//
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            break
//        case .denied:
//                showAlertMassage(title: "Вы запретили использовать геолокацию", massage: "Хотите включить?", url: URL(string: UIApplication.openSettingsURLString))
//        case .authorizedAlways:
//            break
//        case .authorizedWhenInUse:
//            mapView.showsUserLocation = true
//            locationManager.startUpdatingLocation()
//        @unknown default:
//            print("Неизвестная ошибка")
//        }
//    }
//
//    func showAlertMassage(title: String, massage: String?, url: URL?) {
//
//        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
//        let settingAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
//            if let url = url {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//
//        }
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//
//        alert.addAction(settingAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last?.coordinate {
//            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
//            mapView.setRegion(region, animated: true)
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkAutorization()
//    }

}
