//
//  User.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 21.09.2023.
//

import Foundation



struct User : Identifiable {
    
    var id: String
    var email: String
    var name: String
    var lastName: String
    var male: String
    var growth: Int
    var weight: Int
    
    
    var representation : [String: Any] {
        
        var repres = [String: Any]()
        
        repres["id"] = self.id
        repres["email"] = self.email
        repres["name"] = self.name
        repres["lastName"] = self.lastName
        repres["male"] = self.male
        repres["growth"] = self.growth
        repres["weight"] = self.weight
        
        return repres
        
    }
}
