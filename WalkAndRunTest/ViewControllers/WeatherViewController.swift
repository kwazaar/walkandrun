//
//  WeatherViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 02.11.2023.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    var weatherService = WeatherAPI()
    var locations: Step?
    var weatherData: WeatherData?
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
//        guard let currentLocation = locationManager.location?.coordinate else { return }
//        location.latitude = currentLocation.latitude
//        location.longitude = currentLocation.longitude
        guard let location = locations else { return }
        print(location)
        weatherService.getWeatherForecast(location: location, days: 1) { result in
            switch result {
                case .success(let data):
                
                do {
                    let decodeData = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        
                        self.weatherData = decodeData
                        print("Количество дней")
                        
                    }

                } catch {
                    print(error.localizedDescription)
                    print("ебучая ошибка")
                }
                case .failure(let error):
                    print("Error: \(error)")
                    print("другая ебучая ошибка")
                }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weatherData = weatherData else { return 1 }
        return weatherData.forecast.forecastday.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellWeather", for: indexPath) as! WeatherCollectionViewCell
        guard let weatherData = weatherData else { return cell }
        cell.iconWeather.image = UIImage(named: String(weatherData.forecast.forecastday[indexPath.row].condition.code))
        
        return cell
    }
}
