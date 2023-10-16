//
//  MapSerchViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 10.10.2023.
//

import UIKit
import MapKit
import CoreMotion

class MapSerchViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Update")
    }
    
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var serchButton: UIButton!
    @IBOutlet weak var routeView: UIView!
    
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var distanceTravel: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var startRouteButton: UIButton!
    @IBOutlet weak var constraintShowButton: NSLayoutConstraint!
    @IBOutlet weak var textRoute: UILabel!
    
    let locationManager = CLLocationManager()
    let searchController = UISearchController(searchResultsController: nil)
    var destinationCoordinate: CLLocationCoordinate2D?
    var anotationsArray = [MKPointAnnotation]()
    var userLocationSet = false
    var userStartRoute = false
    
    let motionManager = CMMotionManager()
    var currentRotation: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serchButton.isHidden = true
        routeView.isHidden = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        mapView.addGestureRecognizer(longPressGesture)
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск места"
        searchController.searchBar.delegate = self
        
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        startUpdateMotionManager()
        
    }
    
    func startUpdateMotionManager() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data , error in
                guard let attitude = data?.attitude else { return }
                if self!.userStartRoute {
                    self?.routeMap(rotation: attitude.yaw)
                }
            }
        } else {
            print("Гироскоп не активен")
        }
    }
    
    func routeMap(rotation: Double) {
        
        let degrees = rotation * (180 / .pi) + 35
        
            currentRotation = -degrees
            mapView.camera.heading = currentRotation
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func performSearch() {
        
         guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
             return
         }
         
         let request = MKLocalSearch.Request()
         request.naturalLanguageQuery = searchText
         
         let search = MKLocalSearch(request: request)
         search.start { (response, error) in
             guard let response = response else {
                 if let error = error {
                     print("Error occurred in search: \(error.localizedDescription)")
                 }
                 return
             }
             
             self.mapView.removeAnnotations(self.mapView.annotations)
             
             for item in response.mapItems {
                 let annotation = MKPointAnnotation()
                 annotation.coordinate = item.placemark.coordinate
                 annotation.title = item.name
                 self.mapView.addAnnotation(annotation)
             }
         }
     }
    
    @IBAction func showRoute(_ sender: UIButton) {
        drawRouteToMarker()
        routeView.isHidden = false
    }
    
    @IBAction func startRoute(_ sender: UIButton) {
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        userStartRoute.toggle()
        if userStartRoute {
            startRouteButton.setTitle("Окончить маршрут", for: .normal)
            startRouteButton.setTitleColor(.orange, for: .normal)
            constraintShowButton.constant = CGFloat(integerLiteral: -90)
            textRoute.isHidden = false
        } else {
            constraintShowButton.constant = CGFloat(integerLiteral: 20)
            routeView.isHidden = true
            serchButton.isHidden = true
            textRoute.isHidden = true
            startRouteButton.setTitleColor(.white, for: .normal)
            if !mapView.overlays.isEmpty, !mapView.annotations.isEmpty {
                mapView.removeOverlay(mapView.overlays.first!)
                mapView.removeAnnotations(anotationsArray)
            }
            startRouteButton.setTitle("Начать маршрут", for: .normal)
            
        }
    }
    
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            addMarkerToMapView(coordinate: coordinate)
            
            
        }
    }
    
    func addMarkerToMapView(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        if anotationsArray.count >= 2 {
            mapView.removeAnnotation(anotationsArray.removeFirst())
        }
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        anotationsArray.append(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
    }
    
    func drawRouteToMarker() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        guard let destinationCoordinate = destinationCoordinate else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = destinationCoordinate
        mapView.addAnnotation(annotation)
        
        let endPoint = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            guard let response = response else { return }
            
            for route in response.routes {
                if !self.mapView.overlays.isEmpty {
                    self.mapView.removeOverlay(self.mapView.overlays.first!)
                }
                if self.anotationsArray.count > 1 {
                    self.mapView.removeAnnotation(self.anotationsArray.removeFirst())
                }
                self.mapView.addOverlay(route.polyline)
            }
            let route: MKRoute = response.routes[0]
            self.distanceTravel.text = String(format: "%.2f км", route.distance / 1000)
            self.travelTime.text = self.formatTime(seconds: route.expectedTravelTime)
            self.arrivalTime.text = self.getArrivalTime(second: route.expectedTravelTime)
            guard let nextStep = route.steps.first else { return }
            self.textRoute.text = nextStep.instructions
        }
    }
    func getArrivalTime(second: TimeInterval) -> String {
        let date = Date()
        let arrivalDate = date.addingTimeInterval(second)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        
        let formatedTime = dateFormater.string(from: arrivalDate)
        return formatedTime
    }
    
    func formatTime(seconds: TimeInterval) -> String {
        let dateFormater = DateComponentsFormatter()
        dateFormater.unitsStyle = .abbreviated
        dateFormater.allowedUnits = [.hour, .minute]
        dateFormater.maximumUnitCount = 2
        
        if let formatedTime = dateFormater.string(from: seconds) {
            return formatedTime
        } else {
            return "Не определено"
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker")
            if annotationView == nil {
                let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                markerView.canShowCallout = true
                markerView.animatesWhenAdded = true
                return markerView
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !userLocationSet {
            if let location = locationManager.location?.coordinate {
                 let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(region, animated: true)
            }
            userLocationSet = true
        }
        if userStartRoute {
            drawRouteToMarker()
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .orange
        render.lineWidth = 4
        return render
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedMarker = view.annotation as? MKPointAnnotation {
            destinationCoordinate = selectedMarker.coordinate
            serchButton.isHidden = false
        }
    }
}
