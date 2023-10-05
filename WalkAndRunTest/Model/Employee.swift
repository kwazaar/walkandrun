//
//  Employee.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 28.09.2023.
//

import Foundation
import RealmSwift

final class Employee: Object {
    
    @Persisted var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var lastName: String = ""
    @Persisted var email: String = ""
    @Persisted var male: String = ""
    @Persisted var growth: String = ""
    @Persisted var weight: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
