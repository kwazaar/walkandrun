//
//  WeatherAPI.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 01.11.2023.
//

import Foundation


class WeatherAPI {
    
    let apiKey: String = "dbee7487973248f1bad22832230111"
    let baseURL: String = "https://api.weatherapi.com/v1/"
    
    
    func getCurrentWeather(location: Step, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let endpoint = "current.json"
        if let url = URL(string: "\(baseURL)\(endpoint)?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&lang=ru") {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let customError = NSError(domain: "com.weatherapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(customError))
                    return
                }

                completion(.success(data))
            }.resume()
        }
    }
    
    func getWeatherForecast(location: Step, days: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        
            let endpoint = "forecast.json"
        if let url = URL(string: "\(baseURL)\(endpoint)?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&days=\(days)") {
            print("URL: \(url)/n_______________________")
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        
                        completion(.failure(error))
                        
                    } else if let data = data {
                        
                        completion(.success(data))
                    }
                }.resume()
            }
        }
    
}
