//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 4.11.2022.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()

    private func request(path: String) -> DataRequest {
        return AF.request(path, encoding: JSONEncoding.default).validate()
    }
}


extension NetworkManager {
    func fetchData<T>(path: String,expecting: T.Type, onSucces: @escaping (T) -> Void, onError: (AFError) -> Void) where T: Decodable {
            request(path: path).responseDecodable(of: expecting) { response in
                guard let model = response.value else { print(response.error as Any); return }
                onSucces(model)
            }
    }
//    func fetchDataAsList<T>(path: String, onSucces: @escaping (T) -> Void, onError: (AFError) -> Void) where T: Decodable {
//        request(path: path).responseDecodable(of: [T].self) { response in
//            guard let model = response.value, !model.isEmpty else { print(response.error as Any); return }
//            onSucces(model[0])
//        }
//    }
}

