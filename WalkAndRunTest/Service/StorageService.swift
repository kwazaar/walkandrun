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
//    private var avatarsRef: StorageReference { storage.child("avatars") }
    
    func uploadImage(id: String, image: Data, complition: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child("newsImage").child(id)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        ref.putData(image, metadata: metadata) { metadata, error in
            
            guard let _ = metadata else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            ref.downloadURL { url, error in
                guard let url = url else {
                    if let error = error {
                       complition(.failure(error))
                    }
                    return
                }
               complition(.success(url))
            }
        }
    }
    
    func upload(id: String, image: Data, complition : @escaping (Result<URL, Error>) -> Void) {
        
        let ref = Storage.storage().reference().child("avatars").child(id)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        
        ref.putData(image, metadata: metadata) { metadata, error in
            
            guard let _ = metadata else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            ref.downloadURL { url, error in
                guard let url = url else {
                    if let error = error {
                       complition(.failure(error))
                    }
                    return
                }
               complition(.success(url))
            }
        }
    }
    
    func downloadImage(id: String, complition: @escaping (Result<Data, Error>) -> ()) {
        
        let ref = Storage.storage().reference().child("newsImage").child(id)
        
        ref.getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            complition(.success(data))
        }
    }
    
    func downloadAvatar(id: String, complition: @escaping (Result<Data, Error>) -> ()) {
        
        let ref = Storage.storage().reference().child("avatars").child(id)
        
        ref.getData(maxSize: 2 * 1024 * 1024) { data, error in
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

