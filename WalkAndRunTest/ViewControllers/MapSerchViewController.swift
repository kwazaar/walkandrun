//
//  MapSerchViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 10.10.2023.
//

import UIKit
import MapKit

class MapSerchViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Update")
    }
    
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var serchButton: UIButton!
    
    let locationManager = CLLocationManager()
    let searchController = UISearchController(searchResultsController: nil)
    var destinationCoordinate: CLLocationCoordinate2D?
    var anotationsArray = [MKPointAnnotation]()
    var userLocationSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serchButton.isHidden = true
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
             
             // Удалить предыдущие аннотации на карте
             self.mapView.removeAnnotations(self.mapView.annotations)
             
             // Добавить новые аннотации на карту на основе результатов поиска
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
