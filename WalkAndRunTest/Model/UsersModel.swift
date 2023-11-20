//
//  UsersModel.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 18.11.2023.
//

import Foundation



struct UsersModel {
    
    var users: [String]
    
    
    var representation: [String: Any] {
        
        var repres = [String: Any]()
        
        repres["users"] = self.users
        
        return repres
    }
    
}
