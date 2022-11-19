//
//  HomeService.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 4.11.2022.
//

import Foundation
import Alamofire

protocol HomeServiceProtocol {
    func fetchCityLocation(city: String, onSucces: @escaping (City)->Void, onError: @escaping (AFError)->Void)
    func fetchWeather(lon: String,lat: String, onSucces: @escaping (Weather)->Void, onError: @escaping (AFError)->Void)
}

final class HomeService : HomeServiceProtocol {
    
    func fetchWeather(lon: String, lat: String, onSucces: @escaping (Weather) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        NetworkManager.shared.fetchData(path: APIURLs.getWeatherWithLocationUrl(latitude: lat, longitude: lon), expecting: Weather.self) { [weak self] weather in
            onSucces(weather)
        } onError: { error in
            onError(error)
        }
    }
    
    func fetchCityLocation(city: String, onSucces: @escaping (City)->Void, onError: @escaping (AFError)->Void) {
        NetworkManager.shared.fetchData(path: APIURLs.getCityLocationUrl(city: city), expecting: [City].self) { [weak self] city in
            onSucces(city[0])
        } onError: { error in
            onError(error)
        }
    }
    
}
