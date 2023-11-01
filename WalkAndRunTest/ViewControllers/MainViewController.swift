//
//  MainViewController.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 19.09.2023.
//

import UIKit
import RealmSwift


class MainViewController: UIViewController {
    
    @IBOutlet weak var tempWeather: UILabel!
    @IBOutlet weak var cityWeather: UILabel!
    @IBOutlet weak var conditionsWeather: UILabel!
    
    var weatherService = WeatherAPI(apiKey: "dbee7487973248f1bad22832230111")
    var location: Step = Step()
    var weatherData: WeatherResponse?

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        location.latitude = 55.764094
        location.longitude = 37.617617
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

}
