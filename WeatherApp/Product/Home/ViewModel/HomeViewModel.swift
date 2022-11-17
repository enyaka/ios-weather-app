//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 4.11.2022.
//

import Foundation

final class HomeViewModel {
    
    private let service : HomeService
    weak var delegate : HomeViewController?
    var weather : Weather?
    
    init(service: HomeService) {
        self.service = service
    }
    
    func fetchCityLocation(city: String) {
        self.delegate?.loadingState()
        service.fetchCityLocation(city: city) { [weak self] city in
            guard let self = self else {return}
                let lon = String(city.lon ?? 0)
                let lat = String(city.lat ?? 0)
                self.fetchWeather(lon: lon, lat: lat)      
        } onError: { error in
            self.delegate?.failedState(error: error.localizedDescription)
        }
    }
    
    func fetchWeather(lon: String, lat: String) {
        self.delegate?.loadingState()
        service.fetchWeather(lon: lon, lat: lat) { [weak self] weather in
            self?.weather = weather
            self?.delegate?.completeState()
        } onError: { error in
            self.delegate?.failedState(error: error.localizedDescription)
        }
    }
}
