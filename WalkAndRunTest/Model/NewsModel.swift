//
//  NewsModel.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 09.11.2023.
//

import Foundation


struct NewsModel {
    
    var id: String = UUID().uuidString
    var userName: String
    var date: String
    var profilePhoto: String
    var textPost: String
    var imagePost: String?
    
    var representation : [String: Any] {
        
        var repres = [String: Any]()
        
        repres["id"] = self.id
        repres["userName"] = self.userName
        repres["date"] = self.date
        repres["profilePhoto"] = self.profilePhoto
        repres["textPost"] = self.textPost
        repres["imagePost"] = self.imagePost
        
        return repres
        
    }
    
}
