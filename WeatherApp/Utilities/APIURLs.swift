//
//  APIURLs.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 3.11.2022.
//

import Foundation

enum APIURLs {
    static func getCityLocationUrl(city: String) -> String{
        return "https://api.openweathermap.org/geo/1.0/direct?q=\(city.capitalized)&limit=1&appid=\(APIKey.Key.rawValue)"
    }
    
    static func getWeatherWithLocationUrl(latitude: String, longitude: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey.Key.rawValue)&units=metric"
    }
    
    static func getWeatherIconUrl(iconCode: String, iconSize: IconSize) -> String {
        return "https://openweathermap.org/img/wn/\(iconCode)@\(iconSize.rawValue).png"
    }
}
