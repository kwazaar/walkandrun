//
//  NavigationViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 05.10.2023.
//

import UIKit
import MapKit
import RealmSwift


class NavigationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var realmService = RealmService()
    var routeModel = RouteModel()
    var route = List<Step>()
    var user = RouteModel()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startRouteButton: UIButton!
    
    @IBOutlet weak var infoRouteView: UIView!
    @IBOutlet weak var runTimer: UILabel!
    @IBOutlet weak var distanceTravaling: UILabel!
    @IBOutlet weak var mediumTemp: UILabel!
    
    let locationManager = CLLocationManager()
    var setLocation = true
    var startRoute = true
    var routeCoordinates: [CLLocationCoordinate2D] = []
    var timer = Timer()
    var seconds = 0
    var isTimerRunning = false
    var polylineRect = MKMapRect()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocation = true
        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        view.addSubview(userTrackingButton)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -100),
                                     userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20)])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationEnabled()
        checkAutorization()
        mapView.delegate = self
    }
    
    
    
    @IBAction func startRoute(_ sender: UIButton) {
        if startRoute {
            
            startRouteButton.setTitle("Окончить маршрут", for: .normal)
            startRoute = false
            startTimer()
        } else {
            
            let alert = UIAlertController(title: "Вы действительно хотите закончить маршрут?", message: "После завершения маршрута он сохраниться в историю маршрутов", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Завершить", style: .default) { _ in
                
                self.routeModel.time = self.seconds
                self.routeModel.route = self.route
                
                try? self.realmService.localRealm.write {
                    
                    self.realmService.localRealm.add(self.routeModel)
                    print("Выполнил запись")
                }
                self.route = List<Step>()
                self.distanceTravaling.text = "0"
                self.mapView.removeOverlays(self.mapView.overlays)
                self.startRoute = true
                self.stopTimer()
            }
            let cancelAction = UIAlertAction(title: "Нет", style: .destructive)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
            
            
            startRouteButton.setTitle("Начать маршрут", for: .normal)
            
        }
    }
    func calculateRouteDistance(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) -> Double {
        
            let earthRadius = 6371.0 // Радиус Земли в километрах
            let lat1 = startPoint.latitude.degreesToRadians
            let lon1 = startPoint.longitude.degreesToRadians
            let lat2 = endPoint.latitude.degreesToRadians
            let lon2 = endPoint.longitude.degreesToRadians
            
            let dlon = lon2 - lon1
            let dlat = lat2 - lat1
            
            let a = sin(dlat/2) * sin(dlat/2) + cos(lat1) * cos(lat2) * sin(dlon/2) * sin(dlon/2)
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            
            let distance = earthRadius * c // Расстояние в километрах
            return distance
        
    }
    
    func totalDistanceBetweenPoints(locations: [CLLocationCoordinate2D]) -> Double {
        var totalDistance: Double = 0
        
        guard locations.count > 1 else {
            return totalDistance
        }
        
        for i in 0..<locations.count - 1 {
            let distance = calculateRouteDistance(startPoint: locations[i] , endPoint: locations[i + 1])
            totalDistance += distance
        }
        
        return totalDistance
    }
    
    
    func checkLocationEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.setupManager()

            } else {
                self.showAlertMassage(title: "Перейдите в настойки и включите геолокацию", massage: "Перейти", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
            }
        }

    }

    func setupManager() {

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

    }

    func checkAutorization() {

        switch locationManager.authorizationStatus {

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
                showAlertMassage(title: "Вы запретили использовать геолокацию", massage: "Хотите включить?", url: URL(string: UIApplication.openSettingsURLString))
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Неизвестная ошибка")
        }
    }

    func showAlertMassage(title: String, massage: String?, url: URL?) {

        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(settingAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last?.coordinate {
            
            if !startRoute {
                if seconds < 3 {
                    mediumTemp.text = "Определение..."
                } else {
                    let temp = (((totalDistanceBetweenPoints(locations: routeCoordinates) * 1000) / Double(seconds)) * 60) / 1000
                    mediumTemp.text = String(format: "%.2f м/мин", temp)
                }
                routeCoordinates.append(location)
                distanceTravaling.text = String(format: "%.2f м", totalDistanceBetweenPoints(locations: routeCoordinates) * 1000)
                route.append(Step(latitude: location.latitude, longitude: location.longitude))
                drawRoute()
            }
            if setLocation {
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
                setLocation = false
            }
            
        }
    }
    
    func drawRoute() {
        
        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        mapView.addOverlay(polyline)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAutorization()
    }
    
    @objc func updateTimer() {
        seconds += 1
        runTimer.text = formatTime(seconds: Double(seconds))
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
        
    }
    
    func stopTimer() {
        timer.invalidate()
        seconds = 0
        runTimer.text = "0:00:00"
        isTimerRunning = false
    }
    func formatTime(seconds: TimeInterval) -> String {
        let dateFormater = DateComponentsFormatter()
        dateFormater.unitsStyle = .positional
        dateFormater.allowedUnits = [.hour, .minute, .second]
        
        let timeInterval = TimeInterval(seconds)
        if let formatedTime = dateFormater.string(from: timeInterval) {
            return formatedTime
        } else {
            return "Не определено"
        }
    }

}
