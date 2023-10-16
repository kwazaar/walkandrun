//
//  DatabaseService.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 21.09.2023.
//

import Foundation
import FirebaseFirestore


class DatabaseService {
    
    static let shared = DatabaseService()
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private init () { }
    
    func setProfile(user: AppUser, completion: @escaping ((Result <AppUser, Error>) -> ())) {
        
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func getProfile(completion: @escaping (Result<AppUser, Error>) -> ()) {
        
        usersRef.document(AuthService.shared.currentUser!.uid).getDocument { documentSnapshor, error in
            guard let snap = documentSnapshor else { return }
            guard let data = snap.data() else { return }
            
            guard let email = data["email"] as? String else { return }
            guard let id = data["id"] as? String else { return }
            guard let name = data["name"] as? String else { return }
            guard let lastName = data["lastName"] as? String else { return }
            guard let male = data["male"] as? String else { return }
            guard let growth = data["growth"] as? String else { return }
            guard let weight = data["weight"] as? String else { return }
            
            let user = AppUser(id: id, email: email, name: name, lastName: lastName, male: male, growth: growth, weight: weight)
            
            completion(.success(user))
        }
    }
}