//
//  NewsViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 09.11.2023.
//

import UIKit
import Alamofire

class NewsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewCellDelegateButton {

    
    var appUser = AppUser(id: "", email: "", name: "", lastName: "", male: "", growth: "", weight: "", urlImage: "", following: [], followers: [])
    var postsArray = [NewsModel]()
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseService.shared.getProfile { result in
            switch result {
            case .success(let user):
                DatabaseService.shared.getNews(user: user) { result in
                    switch result {
                    case .success(let posts):
                        self.postsArray = posts
                        print(self.postsArray)
                        self.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    @IBAction func addNews(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "WriteNewsViewController") as! WriteNewsViewController
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCollectionViewCell
        cell.delegate = self
        let news = postsArray[indexPath.row]
        if let imageURL = news.imagePost {
            AF.request(imageURL).response { response in
                guard let data = response.data else { return }
                cell.postImage.image = UIImage(data: data)
            }
        }
        cell.nameLable.text = news.userName
        cell.dateLable.text = news.date
        
        if news.textPost.count > 100 {
            
            cell.showMoreButton.isHidden = false
            
        }
        cell.postText.text = news.textPost
        cell.profilePhoto.image = UIImage(named: news.profilePhoto)
        
        return cell
    }
    
    func showMoreButtonPressed(in cell: NewsCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            
            // Дописать реализацию показать далее в ячейке
            
        }
    }
}
