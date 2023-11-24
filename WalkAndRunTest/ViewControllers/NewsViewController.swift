//
//  NewsViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 09.11.2023.
//

import UIKit
import Alamofire

class NewsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewCellDelegateButton {

    
    
    var testArray = [NewsModel(userId: "", userName: "Maxim Sizov", date: "12 ноября 2023", profilePhoto: "Image", textPost: "Я всегда хотел стать программистом и я им становлюсь", imagePost: "Image2"),NewsModel(userId: "", userName: "Kатя Евдокимова", date: "11 ноября 2023", profilePhoto: "Image1", textPost: "Я люблю слушать музыку и прочувствую каждую нотку из песни при прослушивании. Каждый раз удивляюсь когда нахожу достойную песню и сразу же добавляю ее в плейлист", imagePost: "Image"), NewsModel(userId: "", userName: "Виктор Стрельбин", date: "11 ноября 2023", profilePhoto: "Image1", textPost: "А я работаю ведущим, что бы мне этого не стоило я разввлекаю людей даже когда грустный и совсем нет настроения. Бесконечная сатира моих мыслей проносится над облаком пыли и выходит к облакам прямо на самый верх, это текст сгенерирован просто для того чтобы првоерить на сколько тут возможно сделать красиво", imagePost: nil) ]
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
//        if let image = news.imagePost {
//            cell.postImage.image = UIImage(named: image)
//        }
        
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
