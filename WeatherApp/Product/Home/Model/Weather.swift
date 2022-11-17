//
//  Weather.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 5.11.2022.
//

import Foundation

// MARK: - Weather
struct Weather : Decodable {
    let weather: [WeatherElement]?
    let main: Main?
    let dt, timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Main
struct Main : Decodable{
    let temp, feelsLike: Double?
}

// MARK: - WeatherElement
struct WeatherElement : Decodable{
    let id: Int?
    let main, weatherDescription, icon: String?
}
