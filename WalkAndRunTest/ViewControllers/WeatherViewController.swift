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
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        selectDay = weatherData?.forecast.forecastday.first
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weatherData = weatherData else { return 1 }
        return weatherData.forecast.forecastday.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDay = weatherData?.forecast.forecastday[indexPath.row]
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.backgroundColor = UIColor(named: "bgColor2")
        if selectedIndexPath != indexPath {
            let firstSelectedCell = collectionView.cellForItem(at: selectedIndexPath)
            firstSelectedCell?.backgroundColor = UIColor.clear
            selectedIndexPath = indexPath
        }
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellWeather", for: indexPath) as! WeatherCollectionViewCell
        guard let weatherData = weatherData else { return cell }
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(named: "bgColor2")
            cell.dayWeather.text = "Cегодня"
        } else {
            let date = weatherData.forecast.forecastday[indexPath.row].date
            let formatDate = String(date.suffix(5))
            
            cell.dayWeather.text = String(formatDate)
        }
        cell.layer.cornerRadius = 10
        
        cell.iconWeather.image = UIImage(named: String(weatherData.forecast.forecastday[indexPath.row].day.condition.code))
        cell.maxTemp.text = String(Int(weatherData.forecast.forecastday[indexPath.row].day.maxtemp_c))
        cell.minTemp.text = String(Int(weatherData.forecast.forecastday[indexPath.row].day.mintemp_c))
        
        cell.descriptionWeather.text = weatherData.forecast.forecastday[indexPath.row].day.condition.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHour", for: indexPath) as! HourTableViewCell
        guard let selectDay = selectDay else { return cell }
        cell.imageWeather.image = UIImage(named: String(selectDay.hour[indexPath.row].condition.code))
        let time = selectDay.hour[indexPath.row].time
        let formatTime = time.suffix(6)
        cell.hourWeather.text = String(formatTime)
        cell.tempWeather.text = String(format: "%.2f °C", selectDay.hour[indexPath.row].feelslike_c)
        cell.descriptionWeather.text = selectDay.hour[indexPath.row].condition.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let day = selectDay else { return 0 }
        return day.hour.count
    }

}
