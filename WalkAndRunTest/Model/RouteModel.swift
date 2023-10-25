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
    @Persisted var mail: String = ""
    @Persisted var date: Data = Data()
    var route = List<Step>()
    @Persisted var time: Int = 0
    @Persisted var distance: String = ""
    @Persisted var image = Data()
    
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

final class Step: Object {
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

