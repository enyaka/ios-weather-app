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
        NetworkManager.shared.fetchData(path: APIURLs.getWeatherWithLocationUrl(latitude: lat, longitude: lon)) { [weak self] weather in
            onSucces(weather)
        } onError: { error in
            onError(error)
        }
    }
    
    func fetchCityLocation(city: String, onSucces: @escaping (City)->Void, onError: @escaping (AFError)->Void) {
        NetworkManager.shared.fetchDataAsList(path: APIURLs.getCityLocationUrl(city: city)) { [weak self] city in
            onSucces(city)
        } onError: { error in
            onError(error)
        }
    }
    
}
