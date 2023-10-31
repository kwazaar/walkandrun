//
//  RouteDetailViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 30.10.2023.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeTimer: UILabel!
    @IBOutlet weak var routeDistance: UILabel!
    @IBOutlet weak var routeTemp: UILabel!
    @IBOutlet weak var routeDate: UILabel!
    
    var coordinates = [CLLocationCoordinate2D]()
    var routeModel = RouteModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        for coordinate in routeModel.route {
            coordinates.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        
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
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let spanLat = (maxLat - minLat) * 1.1  // Добавляем 10% запаса по широте
        let spanLon = (maxLon - minLon) * 1.1  // Добавляем 10% запаса по долготе
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                                        span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon))
        mapView.region = region
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        
        routeTimer.text = routeModel.convertStringTime
        routeDistance.text = routeModel.convertStringDistance
        routeTemp.text = routeModel.temp
        
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
    
    func dateFormatter(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let routeDate = dateFormatter.string(from: date)
        return routeDate
    }
    

}
