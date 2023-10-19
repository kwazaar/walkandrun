//
//  Route.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 18.10.2023.
//

import Foundation
import MapKit
import RealmSwift



final class RouteModel: Object {
    
    @Persisted var id: String = UUID().uuidString
    var routeStep = [CLLocationCoordinate2D]()
    @Persisted var time: Int = 0
    @Persisted var distance: String = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

final class Step: Object {
    
    @objc dynamic var firstPoint: Point?
    @objc dynamic var lastPoint: Point?
    
}

final class Point: Object {
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
}
