//
//  WeatherModel.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 01.11.2023.
//

import Foundation

//Запрос на 1 день

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}


struct Current: Codable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let vis_km: Double
    let vis_miles: Double
    let uv: Double
    let gust_mph: Double
    let gust_kph: Double
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}

//Запрос на 24 часа

struct WeatherData: Codable {
    
    let location: Location
    let current: Current
    let forecast: Forecast
    
}

struct Forecast: Codable {

    let forecastday: [ForecastDay]
       
}

struct ForecastDay: Codable {

    let date: String
    let date_epoch: Int
    let day: Day
    let astro: Astro
    let hour: [Hour]
    
}

struct Day: Codable {

    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let avgtemp_f: Double
    let maxwind_mph: Double
    let maxwind_kph: Double
    let totalprecip_mm: Double
    let totalprecip_in: Double
    let totalsnow_cm: Double
    let avgvis_km: Double
    let avgvis_miles: Double
    let avghumidity: Double
    let daily_will_it_rain: Double
    let daily_chance_of_rain: Double
    let daily_will_it_snow: Double
    let daily_chance_of_snow: Double
    let condition: Condition
    let uv: Double
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: Int
    let is_moon_up: Int
    let is_sun_up: Int
}

struct Hour: Codable {
    let time_epoch: Int
    let time: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let windchill_c: Double
    let windchill_f: Double
    let heatindex_c: Double
    let heatindex_f: Double
    let dewpoint_c: Double
    let dewpoint_f: Double
    let will_it_rain: Int
    let chance_of_rain: Int
    let will_it_snow: Int
    let chance_of_snow: Int
    let vis_km: Double
    let vis_miles: Double
    let gust_mph: Double
    let gust_kph: Double
    let uv: Double
}
