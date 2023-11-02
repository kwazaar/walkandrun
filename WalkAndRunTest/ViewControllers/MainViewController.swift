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
    var weatherData: WeatherResponse?
    var locationManager = CLLocationManager()

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        guard let currentLocation = locationManager.location?.coordinate else { return }
        location.latitude = currentLocation.latitude
        location.longitude = currentLocation.longitude
        weatherService.getCurrentWeather(location: location) { result in

            switch result {
                case .success(let data):
                
                do {
                    let decodeData = try JSONDecoder().decode(WeatherResponse.self, from: data)

                    DispatchQueue.main.async {
                        self.weatherData = decodeData
                        self.cityWeather.text = self.weatherData!.location.name
                        self.tempWeather.text = String(Int(self.weatherData!.current.temp_c))
                        self.conditionsWeather.text = self.weatherData?.current.condition.text
                        self.imageWeather.image = UIImage(named: String(self.weatherData!.current.condition.code))
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
        vc.locations = location
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
