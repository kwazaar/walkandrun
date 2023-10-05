//
//  AuthService.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 21.09.2023.
//

import Foundation
import FirebaseAuth


class AuthService {
    
    static let shared = AuthService()
    
    private init () { }
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        
        return auth.currentUser
        
    }
    func singOut() {
        try! auth.signOut()
    }
    
    func singUp (email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                print(result.user)
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
