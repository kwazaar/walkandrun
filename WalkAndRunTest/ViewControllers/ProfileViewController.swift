//
//  ProfileViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var employee = [Employee]()
    var realmService = RealmService()
    var routeModel = [RouteModel]()
    var step = [Step]()
    var arrayCoordinate = [CLLocationCoordinate2D]()
    var user = Employee()
    var endUser = AppUser(id: "", email: "", name: "", lastName: "", male: "", growth: "", weight: "", urlImage: "")
    
    var cooordinateRegion = CLLocation(latitude: 53.1, longitude: 33.2)
    var currentUserId: String = ""
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var male: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var growth: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var savePhotoButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        employee = realmService.localRealm.objects(Employee.self).filter({ $0.email == AuthService.shared.currentUser?.email})
        guard let user = employee.first else { return }
        self.user = user
        self.nameLable.text = user.name
        self.lastName.text = user.lastName
        self.male.text = user.male
        self.mail.text = user.email
        self.growth.text = user.growth
        self.weight.text = user.weight
        self.currentUserId = user.id
        
        endUser = AppUser(id: user.id,
                        email: user.email,
                        name: user.name,
                        lastName: user.lastName,
                        male: user.male,
                        growth: user.growth,
                        weight: user.weight,
                        urlImage: user.urlImage)
        
        routeModel = realmService.localRealm.objects(RouteModel.self).filter({ $0.time > 0 })
        
        savePhotoButton.isHidden = true
        imagePhoto.layer.cornerRadius = 75
        imagePhoto.layer.borderWidth = 0.5
//        imagePhoto.image = UIImage(named: "user")
        
        
            
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        AuthService.shared.singOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeProfilePhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true) {
            self.savePhotoButton.isHidden = false
        }
        
    }
    
    @IBAction func savePhoto(_ sender: UIButton) {
        guard let imageData = imagePhoto.image?.jpegData(compressionQuality: 0.4) else { return }
        
        StorageService.shared.upload(id: user.id, image: imageData) { result in
            switch result {
                
            case .success(let url):
                // не дет записать в реалм базу ссылку
//                self.user.urlImage = url.absoluteString
                self.endUser.urlImage = url.absoluteString
                DatabaseService.shared.setProfile(user: self.endUser) { resultDB in
                    switch resultDB {
                    case .success(_):
                        print("URL image download")
                    case .failure(_):
                        print("URL image not download")
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        savePhotoButton.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        routeModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let route = routeModel[indexPath.row]
        cell.routeTime.text = route.convertStringTime
        cell.routeDistance.text = route.convertStringDistance
        arrayCoordinate = []
        cell.bounds.size.width = 170
        cell.bounds.size.height = 170
        
        
        
        for coordinate in route.route {
            arrayCoordinate.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        if !arrayCoordinate.isEmpty {
            let coordinates = arrayCoordinate
            
            // Находим минимальные и максимальные значения широты и долготы среди всех координат линии
            var minLat = coordinates[0].latitude
            var maxLat = coordinates[0].latitude
            var minLon = coordinates[0].longitude
            var maxLon = coordinates[0].longitude
            
            for coordinate in coordinates {
                minLat = min(minLat, coordinate.latitude)
                maxLat = max(maxLat, coordinate.latitude)
                minLon = min(minLon, coordinate.longitude)
                maxLon = max(maxLon, coordinate.longitude)
            }
            
            // Создаем регион, включающий в себя весь минимальный прямоугольник, окружающий линию
            let centerLat = (minLat + maxLat) / 2
            let centerLon = (minLon + maxLon) / 2
            let spanLat = (maxLat - minLat) * 1.1  // Добавляем 10% запаса по широте
            let spanLon = (maxLon - minLon) * 1.1  // Добавляем 10% запаса по долготе
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                                            span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon))
            
            let options = MKMapSnapshotter.Options()
            options.region = region
            options.size = cell.imageRoute.bounds.size
            options.scale = UIScreen.main.scale
            options.mapType = .standard
            
            let snapshoot = MKMapSnapshotter(options: options)
            snapshoot.start(with: .main) { snapshot, error in
                guard error == nil, let snapshot = snapshot else { return }
                
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: .zero)
                
                if let context = UIGraphicsGetCurrentContext() {
                    let coordinates = coordinates
                    context.beginPath()
                    context.setLineWidth(5)
                    context.setStrokeColor(UIColor.orange.cgColor)
                    var started = false
                    for coordinate in coordinates {
                        let point = snapshot.point(for: coordinate)
                        if started {
                            context.addLine(to: point)
                        } else {
                            context.move(to: point)
                            started = true
                        }
                    }
                    
                    context.strokePath()
                }
                
                
                let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
                cell.imageRoute.image = drawnImage
                
                
            }
        }
        
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RouteDetailViewController") as! RouteDetailViewController
        vc.routeModel = routeModel[indexPath.row]
        self.navigationController?.present(vc, animated: true)
        
    }
    
    func formatTime(seconds: TimeInterval) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm:ss"
        dateFormater.timeZone = TimeZone(identifier: "UTC")
        
        let date = Date(timeIntervalSince1970: seconds)
        let formatedTime = dateFormater.string(from: date)
        return formatedTime
    }
    
}
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imagePhoto.image = image
    }
}
