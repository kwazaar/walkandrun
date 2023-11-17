//
//  WriteNewsViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 15.11.2023.
//

import UIKit

class WriteNewsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var textPost: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var data: String = ""
    var user = AppUser(id: "", email: "", name: "", lastName: "", male: "", growth: "", weight: "", urlImage: "")
    var postImage = [UIImage]()
    var news = NewsModel(userId: "", id: "", userName: "", date: "", profilePhoto: "", textPost: "", imagePost: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        DatabaseService.shared.getProfile { result in
            switch result {
                
            case .success(let user):
                self.user = user
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    @IBAction func pushNews(_ sender: UIButton) {
        data = getDate()
        news.id = UUID().uuidString
        news.userId = user.id
        news.date = data
        let userName = user.name + " " + user.lastName
        news.userName = userName
        news.profilePhoto = user.urlImage
        news.textPost = textPost.text ?? ""
        
        
        if let imageData = postImage.first?.jpegData(compressionQuality: 0.4) {
            StorageService.shared.uploadImage(id: news.id, image: imageData) { resultImageUrl in
                switch resultImageUrl {
                    
                case .success(let url):
                    self.news.imagePost = url.absoluteString
                    DatabaseService.shared.pushNews(news: self.news) { result in
                        switch result {
                        case .success(_):
                            print("Ok")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            news.imagePost = ""
            DatabaseService.shared.pushNews(news: self.news) { result in
                switch result {
                case .success(_):
                    print("Ok")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
    
        }
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsPhotoCell", for: indexPath) as! NewsPhotoCollectionViewCell
        cell.newsPhoto.image = postImage[indexPath.row]
        
        return cell
    }
    func getDate() -> String {
        
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        let formatedDate = dateFormatter.string(from: date)
        
        return formatedDate
    }
    
}

extension WriteNewsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        postImage.append(image)
        collectionView.reloadData()
    }
}
