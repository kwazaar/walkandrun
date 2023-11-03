//
//  WeatherViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 02.11.2023.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource{
    

    var weatherData: WeatherData?
    var locationManager = CLLocationManager()
    var selectDay: ForecastDay?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        selectDay = weatherData?.forecast.forecastday.first
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weatherData = weatherData else { return 1 }
        return weatherData.forecast.forecastday.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDay = weatherData?.forecast.forecastday[indexPath.row]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellWeather", for: indexPath) as! WeatherCollectionViewCell
        guard let weatherData = weatherData else { return cell }
        cell.iconWeather.image = UIImage(named: String(weatherData.forecast.forecastday[indexPath.row].day.condition.code))
        cell.maxTemp.text = String(Int(weatherData.forecast.forecastday[indexPath.row].day.maxtemp_c))
        cell.minTemp.text = String(Int(weatherData.forecast.forecastday[indexPath.row].day.mintemp_c))
        cell.dayWeather.text = weatherData.forecast.forecastday[indexPath.row].date
        cell.descriptionWeather.text = weatherData.forecast.forecastday[indexPath.row].day.condition.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHour", for: indexPath) as! HourTableViewCell
//        guard let weatherData = weatherData else { return cell }
        guard let selectDay = selectDay else { return cell }
        cell.imageWeather.image = UIImage(named: String(selectDay.hour[indexPath.row].condition.code))
        cell.hourWeather.text = selectDay.hour[indexPath.row].time
        cell.tempWeather.text = String(selectDay.hour[indexPath.row].feelslike_c)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let day = selectDay else { return 0 }
        return day.hour.count
    }

}
