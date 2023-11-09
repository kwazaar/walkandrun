//
//  MainViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {
    
    @IBOutlet weak var tempWeather: UILabel!
    @IBOutlet weak var cityWeather: UILabel!
    @IBOutlet weak var conditionsWeather: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!

    
    var weatherService = WeatherAPI()
    var location: Step = Step()
    var weatherResponse: WeatherResponse?
    var weatherData: WeatherData?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        guard let currentLocation = locationManager.location?.coordinate else { return }
        location.latitude = currentLocation.latitude
        location.longitude = currentLocation.longitude
        weatherService.getWeatherForecast(location: location, days: 14) { result in
            switch result {
                case .success(let data):
                
                do {
                    let decodeData = try JSONDecoder().decode(WeatherData.self, from: data)
                    
                    DispatchQueue.main.async {

                        self.cityWeather.text = decodeData.location.name
                        self.tempWeather.text = String(Int(decodeData.current.feelslike_c))
                        self.conditionsWeather.text = decodeData.current.condition.text
                        self.imageWeather.image = UIImage(named: String(decodeData.current.condition.code))
                        
                        self.weatherData = decodeData
                        
                    }

                } catch {
                    print(error.localizedDescription)
                }
                case .failure(let error):
                    print("Error: \(error)")
                }
            
        }
    }
    
    @IBAction func showProfile(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)


    }
    @IBAction func showNavigator( _ sender: UIButton) {
        

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NavigationViewController") as! NavigationViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func showWeather(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
        vc.weatherData = weatherData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showNews(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewsViewController") as! NewsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
