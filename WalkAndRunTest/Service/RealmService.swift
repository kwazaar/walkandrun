//
//  RealmService.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 28.09.2023.
//

import Foundation
import RealmSwift

final class RealmService {
    
    let localRealm = try! Realm()
    
    func deleteAllObjectsFromRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            print("All objects deleted from Realm.")
        }
    }
    
    func saveStep(step: [Step]) {
        try! localRealm.write({
            localRealm.add(step)
            print("Add coordinate")
        })
    }
    
}
