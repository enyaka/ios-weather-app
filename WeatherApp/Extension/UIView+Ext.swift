//
//  UIView+.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 3.11.2022.
//

import UIKit

extension UIView {
    func pinToEdgesOf(view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func dHeight(_ value: Double) -> Double{
        return UIScreen.main.bounds.height * value
    }
    
    func dWidth(_ value: Double) -> Double {
        return UIScreen.main.bounds.width * value
    }

}
