//
//  DatabaseService.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 21.09.2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase


class DatabaseService {
    
    static let shared = DatabaseService()
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var newsRef: CollectionReference {
        return db.collection("news")
    }
    var lastDocument: QueryDocumentSnapshot?
    var news = [NewsModel]()
    
    private init () { }
    
    func pushNews(news: NewsModel, completion: @escaping ((Result<NewsModel, Error>) -> ())) {
        newsRef.document(news.id).setData(news.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(news))
            }
        }
    }

    
    func setProfile(user: AppUser, completion: @escaping ((Result <AppUser, Error>) -> ())) {
        
        usersRef.document(user.email).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    func getNews(user: AppUser, completion: @escaping ((Result<[NewsModel], Error>) -> ())) {
        var query = newsRef.whereField("userId", in: user.following).order(by: "date").limit(to: 30)
        
        if let lastDocument = lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        query.getDocuments { querySnapshot, error in
            
            if let error = error {
                print("Ошибка получения новостей \(error.localizedDescription)")
            } else {
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("Нет дополнительных документов")
                    return
                }
                for document in documents {
                    let data = document.data()
                    
                    guard let id = data["id"] as? String else { return }
                    guard let userId = data["userId"] as? String else { return }
                    guard let userName = data["userName"] as? String else { return }
                    guard let date = data["date"] as? String else { return }
                    guard let profilePhoto = data["profilePhoto"] as? String else { return }
                    guard let textPost = data["textPost"] as? String else { return }
                    guard let imagePost = data["imagePost"] as? String else { return }
                    
                    self.news.append(NewsModel(userId: userId, id: id, userName: userName, date: date, profilePhoto: profilePhoto, textPost: textPost, imagePost: imagePost))
                    
                }
                self.lastDocument = documents.last
            }
            
            completion(.success(self.news))
        }
        
    }

    func getProfile(completion: @escaping (Result<AppUser, Error>) -> ()) {
        
        usersRef.document(AuthService.shared.currentUser!.email!).getDocument { documentSnapshor, error in
            guard let snap = documentSnapshor else { return }
            guard let data = snap.data() else { return }
            
            guard let email = data["email"] as? String else { return }
            guard let id = data["id"] as? String else { return }
            guard let name = data["name"] as? String else { return }
            guard let lastName = data["lastName"] as? String else { return }
            guard let male = data["male"] as? String else { return }
            guard let growth = data["growth"] as? String else { return }
            guard let weight = data["weight"] as? String else { return }
            guard let urlImage = data["urlImage"] as? String else { return }
            guard let following = data["following"] as? [String] else { return }
            guard let followers = data["followers"] as? [String] else { return }
            
            let user = AppUser(id: id, email: email, name: name, lastName: lastName, male: male, growth: growth, weight: weight, urlImage: urlImage, following: following, followers: followers)
            
            completion(.success(user))
        }
    }
    func getUsers(email: String, completion: @escaping (Result<AppUser, Error>) -> ()) {
        
        usersRef.document(email).getDocument { documentSnapshot, error in
            guard let snap = documentSnapshot else { return }
            guard let data = snap.data() else { return }
            
            guard let email = data["email"] as? String else { return }
            guard let id = data["id"] as? String else { return }
            guard let name = data["name"] as? String else { return }
            guard let lastName = data["lastName"] as? String else { return }
            guard let male = data["male"] as? String else { return }
            guard let growth = data["growth"] as? String else { return }
            guard let weight = data["weight"] as? String else { return }
            guard let urlImage = data["urlImage"] as? String else { return }
            guard let following = data["following"] as? [String] else { return }
            guard let followers = data["followers"] as? [String] else { return }
            
            let user = AppUser(id: id, email: email, name: name, lastName: lastName, male: male, growth: growth, weight: weight, urlImage: urlImage, following: following, followers: followers)
            
            completion(.success(user))
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
}
