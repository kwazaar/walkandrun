//
//  StorageManager.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 13.11.2023.
//

import Foundation
import Firebase
import FirebaseStorage


class StorageService {
    static var shared = StorageService()
    
    private init() { }
    
    private let storage = Storage.storage().reference()
    private var avatarsRef: StorageReference { storage.child("avatars") }
    
    func upload(id: String, image: Data, complition : @escaping (Result<String, Error>) -> ()) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        avatarsRef.child(id).putData(image,metadata: metadata) { metadata, error in
            guard let metadata = metadata else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            
            complition(.success("Размер полученого изображения \(metadata.size)"))
        }
    }
    func downloadProductImage(id: String, complition: @escaping (Result<Data, Error>) -> ()) {
        avatarsRef.child(id).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            complition(.success(data))
        }
    }
}

