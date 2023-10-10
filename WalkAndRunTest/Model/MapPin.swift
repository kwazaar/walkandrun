//
//  MapPin.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 10.10.2023.
//

import Foundation
import MapKit
import UIKit


class MapPin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinarte: CLLocationCoordinate2D) {
        self.coordinate = coordinarte
    }
    
}
