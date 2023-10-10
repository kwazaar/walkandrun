//
//  MapSerchViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 10.10.2023.
//

import UIKit
import MapKit

class MapSerchViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var serchButton: UIButton!
    
    let locationManager = CLLocationManager()
    var destinationCoordinate: CLLocationCoordinate2D?
    var anotationsArray = [MKPointAnnotation]()
    
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
        
    }
    
    @IBAction func showRoute(_ sender: UIButton) {
        drawRouteToMarker()
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            addMarkerToMapView(coordinate: coordinate)
            
            serchButton.isHidden = false
            destinationCoordinate = coordinate
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
        
    }
    func drawRouteToMarker() {
        
        
        guard let destinationCoordinate = destinationCoordinate else { return }
        
        let endPoint = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            guard let response = response else { return }
            
            for route in response.routes {
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
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .orange
        render.lineWidth = 4
        return render
    }
}
