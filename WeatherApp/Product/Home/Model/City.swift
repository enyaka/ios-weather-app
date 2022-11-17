//
//  City.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 4.11.2022.
//

import Foundation

struct City : Decodable {
    let name: String?
    let lat, lon: Double?
    let country: String?
}
