//
//  User.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 21.09.2023.
//

import Foundation



struct AppUser : Identifiable {
    
    var id: String
    var email: String
    var name: String
    var lastName: String
    var male: String
    var growth: String
    var weight: String
    var urlImage: String
    var following: [String]
    var followers: [String]
    
    
    var representation : [String: Any] {
        
        var repres = [String: Any]()
        
        repres["id"] = self.id
        repres["email"] = self.email
        repres["name"] = self.name
        repres["lastName"] = self.lastName
        repres["male"] = self.male
        repres["growth"] = self.growth
        repres["weight"] = self.weight
        repres["urlImage"] = self.urlImage
        repres["following"] = self.following
        repres["followers"] = self.followers
        
        return repres
        
    }
}
