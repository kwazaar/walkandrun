//
//  ImageModel.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 25.10.2023.
//

import Foundation
import RealmSwift

final class ImageModel: Object {
    
    @Persisted var image = Data()
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
}
